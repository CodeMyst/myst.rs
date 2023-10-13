module myst;

import vibe.d;
import std.datetime;
import dyaml;
import ffeedd.feed;
import ffeedd.item;
import ffeedd.author;

public struct Post
{
    string title;
    string summary;
    Date date;
    string link;
    string path;
}

void main()
{
    auto router = new URLRouter();

    auto fsettings = new HTTPFileServerSettings();
    fsettings.serverPathPrefix = "/static";

    router.get("/static/*", serveStaticFiles("static/", fsettings));

    auto serverSettings = new HTTPServerSettings();
    serverSettings.bindAddresses = ["127.0.0.1"];
    serverSettings.port = 5005;
    serverSettings.errorPageHandler = toDelegate(&displayError);

    router.registerWebInterface(new RootWeb());

    listenHTTP(serverSettings, router);

    runApplication();
}

void displayError(HTTPServerRequest req, HTTPServerResponse res, HTTPServerErrorInfo error)
{
    import std.file : append;
    import std.datetime.systime : Clock;

    string errorDebug = "";
    debug errorDebug = error.debugMessage;

    res.render!("error.dt", error, errorDebug);
}

Feed getFeed()
{
    const posts = getPosts();

    auto author = Author("CodeMyst <code@myst.rs>");

    auto feed = new Feed("CodeMyst", "https://myst.rs/blog", "Hello! I'm CodeMyst, a software developer that likes to play around with everything. I mostly focus on web and game programming. This is my personal blog.");
    feed.published = DateTime(2023, 10, 13, 16, 00, 00);
    feed.updated = Clock.currTime().toUTC().to!DateTime();
    feed.authors ~= author;

    foreach (post; posts)
    {
        auto feedItem = new FeedItem(post.title, "https://myst.rs/blog/" ~ post.link, post.summary);
        feedItem.published = post.date.to!DateTime();
        feedItem.updated = post.date.to!DateTime();
        feedItem.authors ~= author;

        feed.items ~= feedItem;
    }

    return feed;
}

/++
 + root web interface
 +/
class RootWeb
{
    @path("/")
    void getIndex()
    {
        const posts = getPosts();
        const latestPost = posts[0];

        render!("index.dt", latestPost);
    }

    @path("/blog")
    void getBlog()
    {
        const posts = getPosts();

        render!("blog-list.dt", posts);
    }

    @path("/blog/feed.xml")
    string getRss(HTTPServerResponse res)
    {
        res.contentType = "application/xml";

        return getFeed().createAtomFeed();
    }

    @path("/blog/:post")
    void getPost(string _post)
    {
        import std.algorithm : find;
        import std.file : readText;
        import std.string : indexOf;

        auto posts = getPosts().find!((a, b) => a.link == b)(_post);

        if (posts.length == 0) return;

        auto post = posts[0];

        auto fullContent = post.path.readText();

        const content = fullContent[fullContent.indexOf("---", 4)+4..$];

        render!("blog-post.dt", post, content);
    }

    @path("/:project")
    void getProject(string _project)
    {
        import std.file : exists;

        const project = _project;

        if (!exists("projects/"~project~".md")) return;

        render!("project.dt", project);
    }
}

Post[] getPosts()
{
    import std.file : dirEntries, SpanMode, readText;
    import std.string : indexOf;
    import std.algorithm : sort;
    import std.datetime : Date;

    Post[] posts;

    foreach (postFile; dirEntries("blog/", SpanMode.shallow))
    {
        string text = readText(postFile);
        auto startIdx = 4;
        auto endIdx = text.indexOf("---", startIdx)-1;

        string yaml = text[startIdx..endIdx];

        Node root = Loader.fromString(yaml).load();

        Post p;

        p.title = root["title"].get!string;
        p.summary = root["summary"].get!string;
        p.date = root["date"].get!SysTime.to!Date;
        p.link = root["link"].get!string;
        p.path = postFile;

        posts ~= p;
    }

    posts.sort!((a, b) => 
        a.date > b.date
    );

    return posts;
}


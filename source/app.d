module myst;

import vibe.d;
import std.datetime;
import dyaml;

/++
 + post struct
 +/
public struct Post
{
    ///
    string title;
    ///
    Date date;
    ///
    string link;
    ///
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

/++
 + Renders an error page, everytime an error occured
 +/
void displayError(HTTPServerRequest req, HTTPServerResponse res, HTTPServerErrorInfo error)
{
    import std.file : append;
    import std.datetime.systime : Clock;

    string errorDebug = "";
    debug errorDebug = error.debugMessage;

    res.render!("error.dt", error, errorDebug);
}

/++
 + root web interface
 +/
class RootWeb
{
    @path("/")
    void getIndex()
    {
        render!("index.dt");
    }

    @path("/blog")
    void getBlog()
    {
        const posts = getPosts();

        render!("blog-list.dt", posts);
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
        p.date = cast(Date) root["date"].get!SysTime;
        p.link = root["link"].get!string;
        p.path = postFile;

        posts ~= p;
    }

    posts.sort!((a, b) => 
        a.date > b.date
    );

    return posts;
}


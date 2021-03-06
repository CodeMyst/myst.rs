module myst;

import vibe.d;
import std.datetime;
import dyaml;

///
public enum ProjectType
{
    web,
    games,
    tools,
}

///
public struct Project
{
    ///
    string name;
    ///
    string link;
    ///
    string lang;
    ///
    string langBg;
    ///
    string langFg;
    ///
    string status;
    ///
    string time;
    ///
    string website;
    ///
    string source;
    ///
    string description;
    ///
    string jam;
    ///
    ProjectType projectType;
    ///
    uint stars;

    ///
    this(const Node node)
    {
        import std.conv : to;

        name = node["name"].as!string;
        link = node["link"].as!string;
        lang = node["lang"].as!string;
        langBg = node["lang-bg"].as!string;
        langFg = node["lang-fg"].as!string;
        time = node["time"].as!string;
        website = node["website"].as!string;
        source = node["source"].as!string;
        description = node["description"].as!string;
        stars = node["stars"].as!uint;

        if ("jam" in node)
        {
            jam = node["jam"].as!string;
        }
        else
        {
            jam = null;
        }

        if ("status" in node)
        {
            status = node["status"].as!string;
        }
        else
        {
            status = null;
        }

        const typeString = node["type"].as!string;
        projectType = typeString.to!ProjectType;
    }
}

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

///
string pat;

void main()
{
    pat = getPat();

    // cacheStars();

    auto router = new URLRouter();

    auto fsettings = new HTTPFileServerSettings();
    fsettings.serverPathPrefix = "/static";

    router.get("/static/*", serveStaticFiles("static/", fsettings));

    auto serverSettings = new HTTPServerSettings();
    serverSettings.bindAddresses = ["127.0.0.1"];
    serverSettings.port = 5000;
    serverSettings.errorPageHandler = toDelegate(&displayError);

    router.registerWebInterface(new RootWeb());

    setTimer(1.hours, toDelegate(&cacheStars), true);

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
        Node root = Loader.fromFile("projects.yaml").load();

        Project[] projects;

        foreach (project; root["projects"].sequence)
        {
            auto p = project.as!Project();

            projects ~= p;
        }

        render!("index.dt", projects);
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

uint getRemainingRateLimit()
{
    uint rem = 0;

    const url = "https://api.github.com/rate_limit";

    requestHTTP(url,
        (scope req)
        {
            req.headers.addField("Authorization", "token " ~ pat);
            req.method = HTTPMethod.GET;
        },

        (scope res)
        {
            if (res.statusCode == HTTPStatus.ok)
            {
                auto json = parseJsonString(res.bodyReader.readAllUTF8());

                rem = json["resources"]["core"]["remaining"].get!uint;
            }
        }
    );

    return rem;
}

uint getStars(Project p)
{
    import std.algorithm : startsWith;

    uint stars = 0;

    if (!p.source.startsWith("https://github.com/"))
    {
        return stars;
    }

    if (getRemainingRateLimit() == 0)
    {
        return stars;
    }

    const repo = p.source["https://github.com/".length..$];

    const url = "https://api.github.com/repos/" ~ repo;

    requestHTTP(url,
        (scope req)
        {
            req.headers.addField("Authorization", "token " ~ pat);
            req.method = HTTPMethod.GET;
        },

        (scope res)
        {
            if (res.statusCode == HTTPStatus.ok)
            {
                auto json = parseJsonString(res.bodyReader.readAllUTF8());

                stars = json["stargazers_count"].get!uint;
            }
        }
    );

    return stars;
}

///
string getPat()
{
    import std.file : readText;
    import std.string : strip;

    return readText("pat.txt").strip();
}

///
void cacheStars()
{
    import std.stdio : File;
    import std.conv : to;

    Node root = Loader.fromFile("projects.yaml").load();

    foreach (project; root["projects"].sequence)
    {
        auto p = project.as!Project;
        project["stars"] = getStars(p);
    }

    auto f = File("projects.yaml", "w");

    dumper().dump(f.lockingTextWriter, root);

    f.close();
}

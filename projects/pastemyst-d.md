# pastemyst-d ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/codemyst/pastemyst-d/D) [![DUB](https://img.shields.io/dub/v/pastemyst-d)](https://code.dlang.org/packages/pastemyst-d) [![docs](https://img.shields.io/badge/docs-dpldocs-blue)](https://pastemyst-d.dpldocs.info/)

pastemyst api wrapper written in D

## data

```d
@("getting a language by name")
unittest
{
    assert(getLanguageByName("non existing lang").isNull());
    assert(getLanguageByName("asdasdasd").isNull());

    const lang = getLanguageByName("d").get();

    assert(lang.name == "D");
}

@("getting a language by extension")
unittest
{
    assert(getLanguageByExtension("brokey").isNull());

    const lang = getLanguageByExtension("d").get();

    assert(lang.name == "D");
}
```

## time

```d
@("converting expires in value")
unittest
{
    assert(getExpiresInToUnixTime(1_588_441_258, ExpiresIn.oneWeek) == 1_589_046_058);
}
```

## user

```d
@("user exists")
unittest
{
    assert(userExists("codemyst"));
}

@("getting a user")
unittest
{
    assert(getUser("codemyst").get().publicProfile);
}
```

## paste

```d
@("getting a paste")
unittest
{
    const paste = getPaste("cwy615yg").get();

    assert(paste.title == "DONT DELETE - api example");
}

@("creating a paste")
unittest
{
    const pastyCreateInfo = PastyCreateInfo("pasty1", "plain text", "asd asd asd");

    const createInfo = PasteCreateInfo("api test paste",
            ExpiresIn.never,
            false,
            false,
            "",
            [pastyCreateInfo]);

    const paste = createPaste(createInfo);

    assert(paste.title == createInfo.title);
}

@("creating a private paste")
unittest
{
    import std.process : environment;

    const token = environment.get("TOKEN");

    const pastyCreateInfo = PastyCreateInfo("pasty1", "plain text", "asd asd asd");

    const createInfo = PasteCreateInfo("api test paste",
            ExpiresIn.never,
            true,
            false,
            "",
            [pastyCreateInfo]);

    const paste = createPaste(createInfo, token);

    assert(paste.isPrivate);
}

@("deleting a paste")
unittest
{
    import std.process : environment;

    const token = environment.get("TOKEN");

    const pastyCreateInfo = PastyCreateInfo("pasty1", "plain text", "asd asd asd");

    const createInfo = PasteCreateInfo("api test paste",
            ExpiresIn.never,
            false,
            false,
            "",
            [pastyCreateInfo]);

    const paste = createPaste(createInfo, token);

    deletePaste(paste.id, token);

    assert(getPaste(paste.id, token).isNull());
}

@("editing a paste")
unittest
{
    import std.process : environment;

    const token = environment.get("TOKEN");

    const pastyCreateInfo = PastyCreateInfo("pasty1", "plain text", "asd asd asd");

    const createInfo = PasteCreateInfo("api test paste",
            ExpiresIn.never,
            false,
            false,
            "",
            [pastyCreateInfo]);

    auto paste = createPaste(createInfo, token);

    paste.title = "edited title";

    editPaste(paste, token);
}
```

# Update-Markdown

This script reads a markdown file, and when it finds a marker
like

````
```csharp
// Get-MarkdownSnippet ./Samples/Startup.cs configuration
```
````

and it expands to

```csharp
// Get-MarkdownSnippet ./Samples/Startup.cs configuration
configuration = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .AddJsonFile($"appsettings.{environment}.json", optional: true)
                .AddEnvironmentVariables()
                .Build();
```

# Usage

```
Update-Markdown .\Readme.md | Set-Content .\Readme.md -Encoding UTF-8
```

[//]: # (This may be the most platform independent comment)

# Similar projects

[1] https://github.com/NativeScript/markdown-snippet-injector

[2] https://github.com/polywrap/doc-snippets

[3] https://github.com/endocode/snippetextractor


# Update-MarkdownSnippet

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
Import-Module MarkdownSnippet
Update-MarkdownSnippet .\Readme.md | Set-Content .\Readme.md -Encoding UTF-8
```

# Function reference

```pwsh
Get-MarkdownSnippet -Path .\Samples\Startup.cs -Name configuration -Until '###'
###

# The `Path` to .\Startup.cs is relative to the markdown file
# The `Name` of the snippet is not case-sensitive
# The `Until` segment is forgiving of leading and trailing spaces
```

# Idempotency

The script can be executed multiple times and it will not change
the file if the snippets are unchanged.

# Insertion of snippet

The snippet is inserted from the line below the Get-MarkdownSnippet
directive, up to the triple backticks ```.

This can be changed by passing the `-Until` parameter

# Indentation

The code is automatically indented to the current block.
If you indent with 4 spaces

    ```
    // Get-MarkdownSnippet ./Samples/Startup.cs configuration
    ```

Then the code blocks get indented to 4 spaces as well.

# Error Handling

If the specified file could not be found, then a warning will be emitted,
and any snippets that is present in the Markdown file will be left unchanged.

# Similar projects

[1] https://github.com/NativeScript/markdown-snippet-injector

[2] https://github.com/polywrap/doc-snippets

[3] https://github.com/endocode/snippetextractor

[//]: # (This may be the most platform independent comment)

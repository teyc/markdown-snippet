# Update-MarkdownSnippet

This script reads a markdown file, and when it finds a marker
like

````
```csharp
// Get-MarkdownSnippet ./Samples/Startup.cs configuration
```
````

and given a file `./Samples/Startup.cs` that looks like

```csharp

using System;
using System.IO;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using DiConsoleApp.Services;
using DiConsoleApp.Models;

namespace DiConsoleApp
{
    class Startup
    {
        public readonly IConfiguration configuration;
        public readonly IServiceProvider provider;

        // access the built service pipeline
        public IServiceProvider Provider => provider;

        // access the built configuration
        public IConfiguration Configuration => configuration;

        public Startup()
        {
            //defined using visual studio here no data for environment
            var environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");//Developement|Production|Testing etc

            // snip:configuration
            configuration = new ConfigurationBuilder()
                            .SetBasePath(Directory.GetCurrentDirectory())
                            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                            .AddJsonFile($"appsettings.{environment}.json", optional: true)
                            .AddEnvironmentVariables()
                            .Build();
            // end:configuration

            // instantiate
            var services = new ServiceCollection();

            // add necessary services
            services.AddSingleton<IConfiguration>(configuration);
            services.AddSingleton<ISomeService, SomeService>();
            services.AddSingleton<IConnectionService, ConnectionService>();

            // build the pipeline
            provider = services.BuildServiceProvider();
        }
    }
}
```

and it expands the markdown section to

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

[1] https://github.com/SimonCropp/MarkdownSnippets

[2] https://github.com/NativeScript/markdown-snippet-injector

[3] https://github.com/polywrap/doc-snippets

[4] https://github.com/endocode/snippetextractor

[5] https://github.com/csharp-today/MarkdownCodeEmbed

[//]: # (This may be the most platform independent comment)

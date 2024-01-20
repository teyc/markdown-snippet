
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
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using AspireAWSExample.Web;
using AspireAWSExample.Services;
using AspireAWSExample.Shared.Interfaces;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

builder.Services.AddScoped(sp => new HttpClient { BaseAddress = new Uri(builder.HostEnvironment.BaseAddress) });

var apiBaseUri = new Uri(builder.Configuration.GetSection("ApiBaseUrl").Value!);
builder.Services.AddScoped<ICounterService>(sp => new CounterService(
    new HttpClient { BaseAddress = apiBaseUri }
));
builder.Services.AddScoped<IWeatherForecastService>(sp => new WeatherForecastService(
    new HttpClient { BaseAddress = apiBaseUri }
));

await builder.Build().RunAsync();

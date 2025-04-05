using Xunit;
using Amazon.Lambda.Core;
using Amazon.Lambda.TestUtilities;
using Amazon.Lambda.APIGatewayEvents;
using AspireAWSExample.Shared.Models;

namespace AspireAWSExample.WeatherForecastLambdaFunction.Tests;

public class FunctionTest
{
    [Fact]
    public async Task TestFunctionHandler()
    {
        var function = new Function();
        var context = new TestLambdaContext();
        var request = new APIGatewayHttpApiV2ProxyRequest { };
        var response = await function.FunctionHandler(request, context);
        var forecasts = System.Text.Json.JsonSerializer.Deserialize<WeatherForecast[]>(response.Body);
        Assert.True(forecasts!.Length > 0);
    }
}

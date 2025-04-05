using Xunit;
using Amazon.Lambda.Core;
using Amazon.Lambda.TestUtilities;
using Amazon.Lambda.APIGatewayEvents;

namespace AspireAWSExample.CounterLambdaFunction.Tests;

public class FunctionTest
{
    [Theory]
    [InlineData("-1", "0")]
    [InlineData("0", "1")]
    [InlineData("1", "2")]
    [InlineData("99", "100")]
    [InlineData("100", "101")]
    [InlineData("-99", "-98")]
    [InlineData("-100", "-99")]
    [InlineData("-101", "-100")]
    public void TestCountUpHandler(string x, string expected)
    {
        var function = new Function();
        var context = new TestLambdaContext();
        var request = new APIGatewayHttpApiV2ProxyRequest
        {
            PathParameters = new Dictionary<string, string> { { "x", x } }
        };
        var response = function.CountUpHandler(request, context);

        Assert.Equal(expected, response.Body);
    }

}

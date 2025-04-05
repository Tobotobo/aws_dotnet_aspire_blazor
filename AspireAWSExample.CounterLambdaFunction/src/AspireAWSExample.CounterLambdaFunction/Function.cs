using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace AspireAWSExample.CounterLambdaFunction;

public class Function
{
    public APIGatewayHttpApiV2ProxyResponse CountUpHandler(APIGatewayHttpApiV2ProxyRequest request, ILambdaContext context)
    {
        var x = (int)Convert.ChangeType(request.PathParameters["x"], typeof(int));
        var result = x + 1;
        context.Logger.LogInformation($"x = {x}, result = {result}");

        var response = new APIGatewayHttpApiV2ProxyResponse
        {
            StatusCode = 200,
            Headers = new Dictionary<string, string>
            {
                {"Content-Type", "application/json" },
                { "Access-Control-Allow-Origin", "*" },
            },
            Body = result.ToString()
        };
        return response;
    }
}

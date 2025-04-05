#pragma warning disable CA2252 // This API requires opting into preview features

using Aspire.Hosting.AWS.Lambda;

var builder = DistributedApplication.CreateBuilder(args);

// lambdaHandler -> アセンブリ名::フルクラス名::メソッド名

var countUpLambdaFunction = builder.AddAWSLambdaFunction<Projects.AspireAWSExample_CounterLambdaFunction>(
    name: "CountUpLambdaFunction",
    lambdaHandler: "AspireAWSExample.CounterLambdaFunction::AspireAWSExample.CounterLambdaFunction.Function::CountUpHandler");

var weatherForecastLambdaFunction = builder.AddAWSLambdaFunction<Projects.AspireAWSExample_WeatherForecastLambdaFunction>(
    name: "WeatherForecastLambdaFunction",
    lambdaHandler: "AspireAWSExample.WeatherForecastLambdaFunction::AspireAWSExample.WeatherForecastLambdaFunction.Function::FunctionHandler");

// https://github.com/aws/integrations-on-dotnet-aspire-for-aws/blob/main/src/Aspire.Hosting.AWS/Lambda/APIGatewayExtensions.cs
var apiGateway = builder.AddAWSAPIGatewayEmulator(
    name: "APIGatewayEmulator",
    apiGatewayType: APIGatewayType.HttpV2)
    .WithReference(countUpLambdaFunction, Method.Get, "/countup/{x}")
    .WithReference(weatherForecastLambdaFunction, Method.Get, "/weatherforecast");

var apiGatewayPort = int.Parse(Environment.GetEnvironmentVariable("ASPIRE_AWS_API_GATEWAY_EMULATOR_PORT") ?? "7777");
var endpointAnnotation = apiGateway.Resource.Annotations.OfType<EndpointAnnotation>().First(x => x.Name == "http");
endpointAnnotation.Port = apiGatewayPort;

var web = builder.AddProject<Projects.AspireAWSExample_Web>(
    name: "Web")
    .WithExternalHttpEndpoints()
    .WaitFor(apiGateway);

builder.Build().Run();

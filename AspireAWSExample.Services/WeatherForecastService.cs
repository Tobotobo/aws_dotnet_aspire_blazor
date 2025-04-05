using AspireAWSExample.Shared.Interfaces;
using AspireAWSExample.Shared.Models;

namespace AspireAWSExample.Services;

public class WeatherForecastService(HttpClient httpClient) : IWeatherForecastService
{
    public async Task<WeatherForecast[]> GetWeatherForecastsAsync()
    {
        var response = await httpClient.GetAsync($"weatherforecast");
        if (response.IsSuccessStatusCode)
        {
            var content = await response.Content.ReadAsStringAsync();
            var forecasts = System.Text.Json.JsonSerializer.Deserialize<WeatherForecast[]>(content!);
            return forecasts!;
        }
        else throw new Exception("TODO");
    }
}
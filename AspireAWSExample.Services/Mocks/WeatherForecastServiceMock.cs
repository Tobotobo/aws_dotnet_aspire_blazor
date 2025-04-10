using AspireAWSExample.Shared.Interfaces;
using AspireAWSExample.Shared.Models;

namespace AspireAWSExample.Services;

public class WeatherForecastServiceMock : IWeatherForecastService
{
    public Task<WeatherForecast[]> GetWeatherForecastsAsync()
    {
        return Task.Run(() => new WeatherForecast[] {
            new() { Date = new DateOnly(1999, 1, 1), Summary = "X", TemperatureC = 0 },
            new() { Date = new DateOnly(2000, 1, 1), Summary = "XXX", TemperatureC = 1 },
            new() { Date = new DateOnly(2999, 12, 31), Summary = "0123456789", TemperatureC = 999 }
        });
    }
}
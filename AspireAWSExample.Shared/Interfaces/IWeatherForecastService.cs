using AspireAWSExample.Shared.Models;

namespace AspireAWSExample.Shared.Interfaces;

public interface IWeatherForecastService
{
    public Task<WeatherForecast[]> GetWeatherForecastsAsync();
}
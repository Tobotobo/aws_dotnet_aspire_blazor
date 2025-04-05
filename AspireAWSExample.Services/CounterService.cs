using AspireAWSExample.Shared.Interfaces;

namespace AspireAWSExample.Services;

public class CounterService(HttpClient httpClient) : ICounterService
{
    public async Task<int> CountUpAsync(int currentCount)
    {
        var response = await httpClient.GetAsync($"countup/{currentCount}");
        if (response.IsSuccessStatusCode)
        {
            var content = await response.Content.ReadAsStringAsync();
            if (content != null && int.TryParse(content, out int i))
            {
                return i;
            }
            else throw new Exception("TODO");
        }
        else throw new Exception("TODO");
    }
}

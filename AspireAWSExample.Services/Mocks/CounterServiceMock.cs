using AspireAWSExample.Shared.Interfaces;

namespace AspireAWSExample.Services;

public class CounterServiceMock : ICounterService
{
    public Task<int> CountUpAsync(int currentCount)
    {
        return Task.Run(() => 999);
    }
}

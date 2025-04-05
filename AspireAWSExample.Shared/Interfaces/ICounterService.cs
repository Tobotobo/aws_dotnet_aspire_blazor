namespace AspireAWSExample.Shared.Interfaces;

public interface ICounterService
{
    public Task<int> CountUpAsync(int currentCount);
}
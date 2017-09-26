using NUnit.Framework;
using Shouldly;

namespace CSharpCISample.UnitTests
{
    [TestFixture]
    public class GreeterNunit
    {
        [Test]
        public void ShouldSayHello()
        {
            var greeter = new CSharpCISample.Greeter();
            var greeting = greeter.SayHello("Gal");
            greeting.ShouldBe("Hello Gal");
        }

        [Test]
        public void ShouldSayGoodbye()
        {
            var greeter = new CSharpCISample.Greeter();
            var greeting = greeter.SayGoodbye("Gal");
            greeting.ShouldBe("Goodbye Gal");
        }
    }
}

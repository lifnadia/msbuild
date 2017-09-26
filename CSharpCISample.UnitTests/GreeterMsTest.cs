using Microsoft.VisualStudio.TestTools.UnitTesting;
using Shouldly;

namespace CSharpCISample.UnitTests
{
    [TestClass]
    public class GreeterMsTest
    {
        [TestMethod]
        public void ShouldSayHello()
        {
            var greeter = new CSharpCISample.Greeter();
            var greeting = greeter.SayHello("Gal");
            greeting.ShouldBe("Hello Gal");
        }

        [TestMethod]
        public void ShouldSayGoodbye()
        {
            var greeter = new CSharpCISample.Greeter();
            var greeting = greeter.SayGoodbye("Gal");
            greeting.ShouldBe("Goodbye Gal");
        }
    }
}

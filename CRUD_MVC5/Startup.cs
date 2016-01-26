using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(CRUD_MVC5.Startup))]
namespace CRUD_MVC5
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}

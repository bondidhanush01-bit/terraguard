using Microsoft.Maui.Controls;
using TerraGuard.Maui.Views;

namespace TerraGuard.Maui
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();
            MainPage = new MainPage();
        }
    }
}

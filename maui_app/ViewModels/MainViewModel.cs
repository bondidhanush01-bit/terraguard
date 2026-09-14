using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using TerraGuard.Maui.Models;
using TerraGuard.Maui.Services;

namespace TerraGuard.Maui.ViewModels
{
    public partial class MainViewModel : ObservableObject
    {
        private readonly FirebaseService _firebaseService;

        [ObservableProperty]
        private string _appName = "TerraGuard AI";

        [ObservableProperty]
        private string _appVersion = "v3.0 MAUI-Firebase";

        [ObservableProperty]
        private int _activeCriticalCount;

        [ObservableProperty]
        private SensorStation? _selectedStation;

        [ObservableProperty]
        private PredictionResult _currentPrediction = new();

        [ObservableProperty]
        private string _selectedModel = "ensemble";

        [ObservableProperty]
        private bool _isLiveTelemetryActive = true;

        public ObservableCollection<SensorStation> Stations { get; } = new();
        public ObservableCollection<CitizenReport> Reports { get; } = new();

        public MainViewModel()
        {
            _firebaseService = new FirebaseService();
            LoadInitialData();
            StartLiveTelemetryTimer();
        }

        private void LoadInitialData()
        {
            var initialStations = FirebaseService.GetDefaultFallbackStations();
            Stations.Clear();
            foreach (var st in initialStations)
            {
                var pred = TerraGuardAIEngine.CalculateLandslideRisk(new PredictionParameters
                {
                    SlopeAngle = st.SlopeAngle,
                    DailyRainfall = st.DailyRainfall,
                    Cumulative7dRainfall = st.Cumulative7dRainfall,
                    SoilMoisture0_7cm = st.SoilMoisture.Depth0_7cm,
                    SoilMoisture7_28cm = st.SoilMoisture.Depth7_28cm,
                    SoilMoisture28_100cm = st.SoilMoisture.Depth28_100cm,
                    PorePressure = st.PoreWaterPressure,
                    Ndvi = st.Ndvi,
                    Elevation = st.Elevation,
                    VibrationTilt = st.VibrationTilt
                }, SelectedModel);

                st.RiskScore = pred.RiskScore;
                st.Threat = pred.Threat;
                Stations.Add(st);
            }

            if (Stations.Count > 0)
            {
                SelectedStation = Stations[0];
                RecalculateSelectedPrediction();
            }

            ActiveCriticalCount = Stations.Count(s => s.RiskScore >= 75);
        }

        [RelayCommand]
        private void SelectStation(SensorStation station)
        {
            SelectedStation = station;
            RecalculateSelectedPrediction();
        }

        [RelayCommand]
        private void ChangeAIModel(string modelId)
        {
            SelectedModel = modelId;
            RecalculateSelectedPrediction();
        }

        private void RecalculateSelectedPrediction()
        {
            if (SelectedStation == null) return;

            CurrentPrediction = TerraGuardAIEngine.CalculateLandslideRisk(new PredictionParameters
            {
                SlopeAngle = SelectedStation.SlopeAngle,
                DailyRainfall = SelectedStation.DailyRainfall,
                Cumulative7dRainfall = SelectedStation.Cumulative7dRainfall,
                SoilMoisture0_7cm = SelectedStation.SoilMoisture.Depth0_7cm,
                SoilMoisture7_28cm = SelectedStation.SoilMoisture.Depth7_28cm,
                SoilMoisture28_100cm = SelectedStation.SoilMoisture.Depth28_100cm,
                PorePressure = SelectedStation.PoreWaterPressure,
                Ndvi = SelectedStation.Ndvi,
                Elevation = SelectedStation.Elevation,
                VibrationTilt = SelectedStation.VibrationTilt
            }, SelectedModel);
        }

        private void StartLiveTelemetryTimer()
        {
            var random = new Random();
            Application.Current?.Dispatcher.StartTimer(TimeSpan.FromSeconds(5), () =>
            {
                if (!IsLiveTelemetryActive) return true;

                foreach (var st in Stations)
                {
                    double rainAdd = random.NextDouble() > 0.6 ? random.NextDouble() * 0.8 : 0;
                    st.DailyRainfall = Math.Min(250.0, st.DailyRainfall + rainAdd);

                    double tiltDelta = (random.NextDouble() * 0.04) - 0.02;
                    st.VibrationTilt = Math.Max(0.0, st.VibrationTilt + tiltDelta);

                    double poreDelta = (random.NextDouble() * 0.2) - 0.08;
                    st.PoreWaterPressure = Math.Max(0.5, st.PoreWaterPressure + poreDelta);

                    var pred = TerraGuardAIEngine.CalculateLandslideRisk(new PredictionParameters
                    {
                        SlopeAngle = st.SlopeAngle,
                        DailyRainfall = st.DailyRainfall,
                        Cumulative7dRainfall = st.Cumulative7dRainfall,
                        SoilMoisture0_7cm = st.SoilMoisture.Depth0_7cm,
                        SoilMoisture7_28cm = st.SoilMoisture.Depth7_28cm,
                        SoilMoisture28_100cm = st.SoilMoisture.Depth28_100cm,
                        PorePressure = st.PoreWaterPressure,
                        Ndvi = st.Ndvi,
                        Elevation = st.Elevation,
                        VibrationTilt = st.VibrationTilt
                    }, SelectedModel);

                    st.RiskScore = pred.RiskScore;
                    st.Threat = pred.Threat;
                    st.Status = pred.RiskScore >= 75 ? StationStatus.Critical : pred.RiskScore >= 50 ? StationStatus.Warning : StationStatus.Active;
                    st.LastUpdated = "Just now";
                }

                ActiveCriticalCount = Stations.Count(s => s.RiskScore >= 75);
                if (SelectedStation != null)
                {
                    RecalculateSelectedPrediction();
                }

                return true;
            });
        }

        [RelayCommand]
        private async Task TriggerSOSAsync()
        {
            var sos = new SOSDistressRequest
            {
                Id = $"SOS-{new Random().Next(10000, 99999)}",
                UserName = "MAUI Field Responder",
                UserPhone = "+91 98765 43210",
                Lat = SelectedStation?.Lat ?? 25.2986,
                Lng = SelectedStation?.Lng ?? 91.7321,
                LocationAddress = SelectedStation?.Name ?? "GPS Target Location",
                Timestamp = DateTime.Now.ToShortTimeString(),
                PeopleCount = 1,
                HazardNote = "Priority SOS distress broadcast sent via TerraGuard .NET MAUI."
            };

            await _firebaseService.DispatchSOSRequestAsync(sos);
            await Application.Current?.MainPage?.DisplayAlert("🚨 SOS DISPATCHED", $"Priority Rescue Request {sos.Id} sent to Firebase NDRF Emergency Feed!", "OK")!;
        }
    }
}

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Firebase.Database;
using Firebase.Database.Query;
using Newtonsoft.Json;
using TerraGuard.Maui.Models;

namespace TerraGuard.Maui.Services
{
    public class FirebaseService
    {
        private const string FirebaseDatabaseUrl = "https://terraguard-ai-default-rtdb.firebaseio.com/";
        private readonly FirebaseClient _client;

        public FirebaseService()
        {
            _client = new FirebaseClient(FirebaseDatabaseUrl);
        }

        /// Stream live sensor telemetry updates from Firebase Realtime Database
        public IObservable<SensorStation> StreamStationTelemetry(string stationId)
        {
            return _client
                .Child("sensor_stations")
                .Child(stationId)
                .AsObservable<SensorStation>()
                .Select(item => item.Object);
        }

        /// Upload Citizen Hazard Report to Firebase
        public async Task<string> UploadCitizenReportAsync(CitizenReport report)
        {
            try
            {
                var result = await _client
                    .Child("citizen_reports")
                    .PostAsync(JsonConvert.SerializeObject(report));

                return result.Key;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Firebase Upload Error: {ex.Message}");
                return string.Empty;
            }
        }

        /// Dispatch SOS Emergency Rescue Request to Firebase Emergency Feed
        public async Task<bool> DispatchSOSRequestAsync(SOSDistressRequest request)
        {
            try
            {
                await _client
                    .Child("sos_requests")
                    .Child(request.Id)
                    .PutAsync(JsonConvert.SerializeObject(request));

                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Firebase SOS Error: {ex.Message}");
                return false;
            }
        }

        /// Fetch Initial Sensor Stations List
        public async Task<List<SensorStation>> GetStationsAsync()
        {
            try
            {
                var items = await _client
                    .Child("sensor_stations")
                    .OnceAsync<SensorStation>();

                var list = new List<SensorStation>();
                foreach (var item in items)
                {
                    list.Add(item.Object);
                }
                return list;
            }
            catch
            {
                return GetDefaultFallbackStations();
            }
        }

        public static List<SensorStation> GetDefaultFallbackStations()
        {
            return new List<SensorStation>
            {
                new SensorStation
                {
                    Id = "ST-CHER",
                    Name = "Cherrapunji Station 01",
                    Region = "East Khasi Hills",
                    State = "Meghalaya",
                    Lat = 25.2986,
                    Lng = 91.7321,
                    Elevation = 1484,
                    SlopeAngle = 42,
                    DailyRainfall = 165,
                    Cumulative7dRainfall = 380,
                    SoilMoisture = new SoilMoistureDepths { Depth0_7cm = 96, Depth7_28cm = 92, Depth28_100cm = 88 },
                    PoreWaterPressure = 18.5,
                    SoilType = "Weathered Sandstone & Clay",
                    Ndvi = 0.31,
                    VibrationTilt = 4.8,
                    Status = StationStatus.Critical,
                    PopulationAtRisk = 8450
                },
                new SensorStation
                {
                    Id = "ST-GANG",
                    Name = "Gangtok Ridge Station 04",
                    Region = "East Sikkim",
                    State = "Sikkim",
                    Lat = 27.3389,
                    Lng = 88.6065,
                    Elevation = 1650,
                    SlopeAngle = 38,
                    DailyRainfall = 115,
                    Cumulative7dRainfall = 290,
                    SoilMoisture = new SoilMoistureDepths { Depth0_7cm = 91, Depth7_28cm = 87, Depth28_100cm = 82 },
                    PoreWaterPressure = 14.2,
                    SoilType = "Mica Schist & Gneiss",
                    Ndvi = 0.42,
                    VibrationTilt = 3.2,
                    Status = StationStatus.Critical,
                    PopulationAtRisk = 12200
                },
                new SensorStation
                {
                    Id = "ST-TAWA",
                    Name = "Tawang Pass Station 09",
                    Region = "Tawang District",
                    State = "Arunachal Pradesh",
                    Lat = 27.5861,
                    Lng = 91.8594,
                    Elevation = 3048,
                    SlopeAngle = 44,
                    DailyRainfall = 95,
                    Cumulative7dRainfall = 240,
                    SoilMoisture = new SoilMoistureDepths { Depth0_7cm = 86, Depth7_28cm = 81, Depth28_100cm = 76 },
                    PoreWaterPressure = 11.8,
                    SoilType = "Glacial Till & Colluvium",
                    Ndvi = 0.38,
                    VibrationTilt = 2.6,
                    Status = StationStatus.Warning,
                    PopulationAtRisk = 4100
                }
            };
        }
    }
}

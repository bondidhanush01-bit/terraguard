using System;
using System.Collections.Generic;

namespace TerraGuard.Maui.Models
{
    public enum ThreatLevel
    {
        Normal,
        Advisory,
        Warning,
        Emergency
    }

    public enum StationStatus
    {
        Active,
        Warning,
        Critical,
        Offline
    }

    public class SoilMoistureDepths
    {
        public double Depth0_7cm { get; set; }
        public double Depth7_28cm { get; set; }
        public double Depth28_100cm { get; set; }
    }

    public class SensorStation
    {
        public string Id { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Region { get; set; } = string.Empty;
        public string State { get; set; } = string.Empty;
        public double Lat { get; set; }
        public double Lng { get; set; }
        public double Elevation { get; set; }
        public double SlopeAngle { get; set; }
        public double DailyRainfall { get; set; }
        public double Cumulative7dRainfall { get; set; }
        public SoilMoistureDepths SoilMoisture { get; set; } = new();
        public double PoreWaterPressure { get; set; }
        public string SoilType { get; set; } = string.Empty;
        public double Ndvi { get; set; }
        public double VibrationTilt { get; set; }
        public string LastUpdated { get; set; } = "Just now";
        public StationStatus Status { get; set; } = StationStatus.Active;
        public int PopulationAtRisk { get; set; }
        public int RiskScore { get; set; }
        public ThreatLevel Threat { get; set; } = ThreatLevel.Normal;
    }

    public class PredictionParameters
    {
        public double SlopeAngle { get; set; }
        public double DailyRainfall { get; set; }
        public double Cumulative7dRainfall { get; set; }
        public double SoilMoisture0_7cm { get; set; }
        public double SoilMoisture7_28cm { get; set; }
        public double SoilMoisture28_100cm { get; set; }
        public double PorePressure { get; set; }
        public double Ndvi { get; set; }
        public double Elevation { get; set; }
        public double VibrationTilt { get; set; }
    }

    public class ModelPredictionDetail
    {
        public string Id { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty;
        public int RiskScore { get; set; }
        public ThreatLevel Threat { get; set; }
        public int ConfidencePercentage { get; set; }
        public string Description { get; set; } = string.Empty;
        public string KeyMetric { get; set; } = string.Empty;
        public string KeyMetricValue { get; set; } = string.Empty;
    }

    public class PredictionResult
    {
        public int RiskScore { get; set; }
        public ThreatLevel Threat { get; set; }
        public string ThreatColorHex { get; set; } = "#10B981";
        public int ProbabilityPercentage { get; set; }
        public string EstimatedTimeToSlide { get; set; } = string.Empty;
        public List<string> RecommendedActions { get; set; } = new();
        public bool AlertBroadcastRequired { get; set; }
        public Dictionary<string, ModelPredictionDetail> ModelPredictions { get; set; } = new();
        public int ConsensusAgreement { get; set; } = 94;
        public int VarianceIndex { get; set; } = 12;
    }

    public class CitizenReport
    {
        public string Id { get; set; } = string.Empty;
        public string ReporterName { get; set; } = string.Empty;
        public string LocationName { get; set; } = string.Empty;
        public string State { get; set; } = string.Empty;
        public double Lat { get; set; }
        public double Lng { get; set; }
        public string HazardType { get; set; } = string.Empty;
        public string Severity { get; set; } = string.Empty;
        public string PhotoUrl { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Status { get; set; } = "Verified";
        public string Timestamp { get; set; } = "Just now";
    }

    public class SOSDistressRequest
    {
        public string Id { get; set; } = string.Empty;
        public string UserName { get; set; } = string.Empty;
        public string UserPhone { get; set; } = string.Empty;
        public double Lat { get; set; }
        public double Lng { get; set; }
        public string LocationAddress { get; set; } = string.Empty;
        public string Timestamp { get; set; } = string.Empty;
        public int PeopleCount { get; set; } = 1;
        public string HazardNote { get; set; } = string.Empty;
        public string Status { get; set; } = "DISPATCHED";
    }
}

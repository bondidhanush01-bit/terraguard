import 'package:flutter/material.dart';

void main() {
  runApp(const TerraGuardApp());
}

/// Main Application Entry Point
class TerraGuardApp extends StatelessWidget {
  const TerraGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TerraGuard AI Landslide Early Warning & Mobile GIS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        primaryColor: const Color(0xFF06B6D4),
        cardColor: const Color(0xFF111827),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF06B6D4),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF111827),
          error: Color(0xFFEF4444),
          warning: Color(0xFFF97316),
        ),
      ),
      home: const TerraGuardMainScreen(),
    );
  }
}

// ==========================================
// DATA MODELS
// ==========================================

enum StationStatus { critical, warning, active }
enum ThreatLevel { normal, advisory, warning, emergency }

class SoilMoisture {
  final double depth0_7cm;
  final double depth7_28cm;
  final double depth28_100cm;

  const SoilMoisture({
    required this.depth0_7cm,
    required this.depth7_28cm,
    required this.depth28_100cm,
  });
}

class SensorStation {
  final String id;
  final String name;
  final String region;
  final String state;
  final double lat;
  final double lng;
  final double elevation;
  final double slopeAngle;
  final double dailyRainfall;
  final double cumulative7dRainfall;
  final SoilMoisture soilMoisture;
  final double poreWaterPressure;
  final String soilType;
  final double ndvi;
  final double vibrationTilt;
  final String lastUpdated;
  final StationStatus status;
  final int populationAtRisk;
  int riskScore;
  ThreatLevel threatLevel;

  SensorStation({
    required this.id,
    required this.name,
    required this.region,
    required this.state,
    required this.lat,
    required this.lng,
    required this.elevation,
    required this.slopeAngle,
    required this.dailyRainfall,
    required this.cumulative7dRainfall,
    required this.soilMoisture,
    required this.poreWaterPressure,
    required this.soilType,
    required this.ndvi,
    required this.vibrationTilt,
    required this.lastUpdated,
    required this.status,
    required this.populationAtRisk,
    this.riskScore = 0,
    this.threatLevel = ThreatLevel.normal,
  });
}

class CitizenReport {
  final String id;
  final String reporterName;
  final String reporterRole;
  final String locationName;
  final String state;
  final double lat;
  final double lng;
  final String hazardType;
  final String severity;
  final String photoUrl;
  final String description;
  String status;
  final String timestamp;

  CitizenReport({
    required this.id,
    required this.reporterName,
    required this.reporterRole,
    required this.locationName,
    required this.state,
    required this.lat,
    required this.lng,
    required this.hazardType,
    required this.severity,
    required this.photoUrl,
    required this.description,
    required this.status,
    required this.timestamp,
  });
}

class EarlyWarningAlert {
  final String id;
  final String stationId;
  final String locationName;
  final ThreatLevel threatLevel;
  final int riskScore;
  final String issuedAt;
  final List<String> channels;
  final int affectedPopulation;
  final String actionProtocol;

  const EarlyWarningAlert({
    required this.id,
    required this.stationId,
    required this.locationName,
    required this.threatLevel,
    required this.riskScore,
    required this.issuedAt,
    required this.channels,
    required this.affectedPopulation,
    required this.actionProtocol,
  });
}

class StateHistoricalData {
  final String state;
  final int events;
  final int deaths;
  final int roadBlockades;
  final int avgRiskScore;

  const StateHistoricalData({
    required this.state,
    required this.events,
    required this.deaths,
    required this.roadBlockades,
    required this.avgRiskScore,
  });
}

class MonthlyTrend {
  final String month;
  final double rainfall;
  final int landslides;
  final double avgSoilSat;

  const MonthlyTrend({
    required this.month,
    required this.rainfall,
    required this.landslides,
    required this.avgSoilSat,
  });
}

class FactorContribution {
  final String feature;
  final double weight;
  final int contribution;
  final String description;

  const FactorContribution({
    required this.feature,
    required this.weight,
    required this.contribution,
    required this.description,
  });
}

class PredictionParameters {
  double slopeAngle;
  double dailyRainfall;
  double cumulative7dRainfall;
  double soilMoisture0_7cm;
  double soilMoisture7_28cm;
  double soilMoisture28_100cm;
  double porePressure;
  double ndvi;
  double elevation;
  double vibrationTilt;

  PredictionParameters({
    required this.slopeAngle,
    required this.dailyRainfall,
    required this.cumulative7dRainfall,
    required this.soilMoisture0_7cm,
    required this.soilMoisture7_28cm,
    required this.soilMoisture28_100cm,
    required this.porePressure,
    required this.ndvi,
    required this.elevation,
    required this.vibrationTilt,
  });
}

class PredictionResult {
  final int riskScore;
  final ThreatLevel threatLevel;
  final Color threatColor;
  final int probabilityPercentage;
  final String estimatedTimeToSlide;
  final List<FactorContribution> factorBreakdown;
  final List<String> recommendedActions;
  final bool alertBroadcastRequired;

  const PredictionResult({
    required this.riskScore,
    required this.threatLevel,
    required this.threatColor,
    required this.probabilityPercentage,
    required this.estimatedTimeToSlide,
    required this.factorBreakdown,
    required this.recommendedActions,
    required this.alertBroadcastRequired,
  });
}

// ==========================================
// AI PREDICTION ENGINE
// ==========================================

class TerraGuardAIEngine {
  static PredictionResult calculateRisk(PredictionParameters params) {
    // 1. Slope Angle (25%)
    double slopeScore = 0;
    if (params.slopeAngle < 15) {
      slopeScore = 15;
    } else if (params.slopeAngle < 28) {
      slopeScore = 40;
    } else if (params.slopeAngle < 38) {
      slopeScore = 75;
    } else {
      slopeScore = 95;
    }

    // 2. Daily Rainfall (20%)
    double dailyRainScore = ((params.dailyRainfall / 120) * 100).clamp(0, 100);

    // 3. Soil Moisture Saturation (20%)
    double avgMoisture = (params.soilMoisture0_7cm * 0.3) +
        (params.soilMoisture7_28cm * 0.4) +
        (params.soilMoisture28_100cm * 0.3);
    double saturationScore = 0;
    if (avgMoisture > 85) {
      saturationScore = 98;
    } else if (avgMoisture > 70) {
      saturationScore = 75;
    } else if (avgMoisture > 50) {
      saturationScore = 45;
    } else {
      saturationScore = 20;
    }

    // 4. 7-Day Cumulative Rainfall (15%)
    double cumRainScore = ((params.cumulative7dRainfall / 250) * 100).clamp(0, 100);

    // 5. NDVI Vegetation Cover (10%)
    double vegetationRiskScore = ((1 - params.ndvi) * 100).clamp(0, 100);

    // 6. Geotechnical Pore Pressure & Vibration (10%)
    double geotechnicalScore =
        ((params.porePressure / 12) * 50 + (params.vibrationTilt * 10)).clamp(0, 100);

    // Composite Calculation
    double rawRiskScore = (slopeScore * 0.25) +
        (dailyRainScore * 0.20) +
        (saturationScore * 0.20) +
        (cumRainScore * 0.15) +
        (vegetationRiskScore * 0.10) +
        (geotechnicalScore * 0.10);

    int riskScore = rawRiskScore.round().clamp(0, 100);

    ThreatLevel threatLevel = ThreatLevel.normal;
    Color threatColor = const Color(0xFF10B981);
    String estimatedTimeToSlide = 'Stable (>48 hours)';
    bool alertRequired = false;

    if (riskScore >= 75) {
      threatLevel = ThreatLevel.emergency;
      threatColor = const Color(0xFFEF4444);
      estimatedTimeToSlide = 'IMMINENT THREAT (< 2 Hours)';
      alertRequired = true;
    } else if (riskScore >= 50) {
      threatLevel = ThreatLevel.warning;
      threatColor = const Color(0xFFF97316);
      estimatedTimeToSlide = 'High Danger (6 - 12 Hours)';
      alertRequired = true;
    } else if (riskScore >= 25) {
      threatLevel = ThreatLevel.advisory;
      threatColor = const Color(0xFFF59E0B);
      estimatedTimeToSlide = 'Moderate Risk (12 - 24 Hours)';
    }

    int probability = (riskScore * 0.95 + 4).round().clamp(0, 99);

    List<FactorContribution> breakdown = [
      FactorContribution(
        feature: 'Slope Angle & Gradient',
        weight: 25,
        contribution: (slopeScore * 0.25).round(),
        description: '${params.slopeAngle.toStringAsFixed(0)}° terrain inclination angle',
      ),
      FactorContribution(
        feature: '24h Rain Intensity',
        weight: 20,
        contribution: (dailyRainScore * 0.20).round(),
        description: '${params.dailyRainfall.toStringAsFixed(0)} mm/day precipitation rate',
      ),
      FactorContribution(
        feature: 'Multi-Depth Soil Moisture',
        weight: 20,
        contribution: (saturationScore * 0.20).round(),
        description: '${avgMoisture.toStringAsFixed(1)}% profile saturation (0-100cm)',
      ),
      FactorContribution(
        feature: '7-Day Cumulative Rain',
        weight: 15,
        contribution: (cumRainScore * 0.15).round(),
        description: '${params.cumulative7dRainfall.toStringAsFixed(0)} mm accumulated over 7 days',
      ),
      FactorContribution(
        feature: 'Vegetation Cover (NDVI)',
        weight: 10,
        contribution: (vegetationRiskScore * 0.10).round(),
        description: 'NDVI ${params.ndvi.toStringAsFixed(2)} (${params.ndvi < 0.4 ? 'Low root binding' : 'Dense root binding'})',
      ),
      FactorContribution(
        feature: 'Pore Pressure & Tilt',
        weight: 10,
        contribution: (geotechnicalScore * 0.10).round(),
        description: '${params.porePressure.toStringAsFixed(1)} kPa water pressure / ${params.vibrationTilt.toStringAsFixed(1)} mm/h creep',
      ),
    ];

    List<String> actions = [];
    if (threatLevel == ThreatLevel.emergency) {
      actions = [
        '🚨 IMMEDIATE EVACUATION: Issue priority sirens & SMS warnings to all residents in 3km zone.',
        '🚧 ROAD BLOCKADE: Close mountain pass corridors and deploy traffic police.',
        '🚑 EMERGENCY RESPONSE: Pre-position NDRF teams and emergency rescue units.',
        '📡 HIGH-FREQUENCY MONITORING: Increase IoT telemetry polling rate to 1 min interval.',
      ];
    } else if (threatLevel == ThreatLevel.warning) {
      actions = [
        '⚠️ VOLUNTARY EVACUATION: Notify downhill settlements to move to higher ground.',
        '🚚 HEAVY VEHICLE BAN: Restrict heavy trucks on steep mountain grades.',
        '🔍 FIELD INSPECTION: Dispatch field officers to inspect tension cracks along slope crests.',
      ];
    } else if (threatLevel == ThreatLevel.advisory) {
      actions = [
        '⚡ ENHANCED MONITORING: Track 6-hour rainfall forecasts and pore pressure trends.',
        '📱 DDMA ALERT: Send advisory briefing to District Disaster Management Authority.',
      ];
    } else {
      actions = [
        '✅ ROUTINE SYSTEM CHECK: All geotechnical sensors operating within safe parameters.',
        '📊 DATA LOGGING: Continuous background logging of soil moisture & weather metrics.',
      ];
    }

    return PredictionResult(
      riskScore: riskScore,
      threatLevel: threatLevel,
      threatColor: threatColor,
      probabilityPercentage: probability,
      estimatedTimeToSlide: estimatedTimeToSlide,
      factorBreakdown: breakdown,
      recommendedActions: actions,
      alertBroadcastRequired: alertRequired,
    );
  }
}

// ==========================================
// REPOSITORY / MOCK DATA
// ==========================================

class TerraGuardRepository {
  static List<SensorStation> getInitialStations() {
    final rawStations = [
      SensorStation(
        id: 'ST-CHER',
        name: 'Cherrapunji Station 01',
        region: 'East Khasi Hills',
        state: 'Meghalaya',
        lat: 25.2986,
        lng: 91.7321,
        elevation: 1484,
        slopeAngle: 42,
        dailyRainfall: 165,
        cumulative7dRainfall: 380,
        soilMoisture: const SoilMoisture(depth0_7cm: 96, depth7_28cm: 92, depth28_100cm: 88),
        poreWaterPressure: 18.5,
        soilType: 'Weathered Sandstone & Clay',
        ndvi: 0.31,
        vibrationTilt: 4.8,
        lastUpdated: 'Just now',
        status: StationStatus.critical,
        populationAtRisk: 8450,
      ),
      SensorStation(
        id: 'ST-GANG',
        name: 'Gangtok Ridge Station 04',
        region: 'East Sikkim',
        state: 'Sikkim',
        lat: 27.3389,
        lng: 88.6065,
        elevation: 1650,
        slopeAngle: 38,
        dailyRainfall: 115,
        cumulative7dRainfall: 290,
        soilMoisture: const SoilMoisture(depth0_7cm: 91, depth7_28cm: 87, depth28_100cm: 82),
        poreWaterPressure: 14.2,
        soilType: 'Mica Schist & Gneiss',
        ndvi: 0.42,
        vibrationTilt: 3.2,
        lastUpdated: '1 min ago',
        status: StationStatus.critical,
        populationAtRisk: 12200,
      ),
      SensorStation(
        id: 'ST-TAWA',
        name: 'Tawang Pass Station 09',
        region: 'Tawang District',
        state: 'Arunachal Pradesh',
        lat: 27.5861,
        lng: 91.8594,
        elevation: 3048,
        slopeAngle: 44,
        dailyRainfall: 95,
        cumulative7dRainfall: 240,
        soilMoisture: const SoilMoisture(depth0_7cm: 86, depth7_28cm: 81, depth28_100cm: 76),
        poreWaterPressure: 11.8,
        soilType: 'Glacial Till & Colluvium',
        ndvi: 0.38,
        vibrationTilt: 2.6,
        lastUpdated: '2 mins ago',
        status: StationStatus.warning,
        populationAtRisk: 4100,
      ),
      SensorStation(
        id: 'ST-SHIL',
        name: 'Shillong Peak Monitor 02',
        region: 'East Khasi Hills',
        state: 'Meghalaya',
        lat: 25.5788,
        lng: 91.8933,
        elevation: 1965,
        slopeAngle: 31,
        dailyRainfall: 68,
        cumulative7dRainfall: 155,
        soilMoisture: const SoilMoisture(depth0_7cm: 72, depth7_28cm: 65, depth28_100cm: 60),
        poreWaterPressure: 6.8,
        soilType: 'Quartzite & Phyllite',
        ndvi: 0.58,
        vibrationTilt: 0.9,
        lastUpdated: '3 mins ago',
        status: StationStatus.warning,
        populationAtRisk: 9800,
      ),
      SensorStation(
        id: 'ST-KOHI',
        name: 'Kohima Bypass Station 07',
        region: 'Kohima District',
        state: 'Nagaland',
        lat: 25.6751,
        lng: 94.1086,
        elevation: 1444,
        slopeAngle: 35,
        dailyRainfall: 88,
        cumulative7dRainfall: 195,
        soilMoisture: const SoilMoisture(depth0_7cm: 82, depth7_28cm: 78, depth28_100cm: 74),
        poreWaterPressure: 9.6,
        soilType: 'Disang Shales',
        ndvi: 0.48,
        vibrationTilt: 1.8,
        lastUpdated: '5 mins ago',
        status: StationStatus.warning,
        populationAtRisk: 6300,
      ),
      SensorStation(
        id: 'ST-AIZA',
        name: 'Aizawl Slope Monitor 06',
        region: 'Aizawl District',
        state: 'Mizoram',
        lat: 23.7271,
        lng: 92.7176,
        elevation: 1132,
        slopeAngle: 39,
        dailyRainfall: 104,
        cumulative7dRainfall: 260,
        soilMoisture: const SoilMoisture(depth0_7cm: 89, depth7_28cm: 85, depth28_100cm: 80),
        poreWaterPressure: 13.1,
        soilType: 'Siltstone & Sandstone',
        ndvi: 0.39,
        vibrationTilt: 3.7,
        lastUpdated: '2 mins ago',
        status: StationStatus.critical,
        populationAtRisk: 11500,
      ),
      SensorStation(
        id: 'ST-IMPH',
        name: 'Imphal Valley Highway 08',
        region: 'Imphal West',
        state: 'Manipur',
        lat: 24.817,
        lng: 93.9368,
        elevation: 786,
        slopeAngle: 26,
        dailyRainfall: 45,
        cumulative7dRainfall: 105,
        soilMoisture: const SoilMoisture(depth0_7cm: 58, depth7_28cm: 52, depth28_100cm: 48),
        poreWaterPressure: 4.2,
        soilType: 'Alluvium Clay',
        ndvi: 0.65,
        vibrationTilt: 0.3,
        lastUpdated: '6 mins ago',
        status: StationStatus.active,
        populationAtRisk: 5200,
      ),
      SensorStation(
        id: 'ST-ITAN',
        name: 'Itanagar Hills Station 05',
        region: 'Papum Pare',
        state: 'Arunachal Pradesh',
        lat: 27.0844,
        lng: 93.6053,
        elevation: 320,
        slopeAngle: 24,
        dailyRainfall: 32,
        cumulative7dRainfall: 80,
        soilMoisture: const SoilMoisture(depth0_7cm: 45, depth7_28cm: 40, depth28_100cm: 36),
        poreWaterPressure: 2.8,
        soilType: 'Siwalik Sandstone',
        ndvi: 0.74,
        vibrationTilt: 0.1,
        lastUpdated: '8 mins ago',
        status: StationStatus.active,
        populationAtRisk: 7100,
      ),
      SensorStation(
        id: 'ST-HAFL',
        name: 'Haflong Hill Station 11',
        region: 'Dima Hasao',
        state: 'Assam',
        lat: 25.1764,
        lng: 93.0163,
        elevation: 512,
        slopeAngle: 37,
        dailyRainfall: 112,
        cumulative7dRainfall: 275,
        soilMoisture: const SoilMoisture(depth0_7cm: 94, depth7_28cm: 90, depth28_100cm: 85),
        poreWaterPressure: 15.4,
        soilType: 'Tertiary Shale',
        ndvi: 0.34,
        vibrationTilt: 4.1,
        lastUpdated: 'Just now',
        status: StationStatus.critical,
        populationAtRisk: 8900,
      ),
      SensorStation(
        id: 'ST-AGAR',
        name: 'Jampui Hills Station 10',
        region: 'North Tripura',
        state: 'Tripura',
        lat: 23.9167,
        lng: 92.2833,
        elevation: 600,
        slopeAngle: 22,
        dailyRainfall: 28,
        cumulative7dRainfall: 62,
        soilMoisture: const SoilMoisture(depth0_7cm: 38, depth7_28cm: 35, depth28_100cm: 32),
        poreWaterPressure: 1.9,
        soilType: 'Loamy Sand',
        ndvi: 0.79,
        vibrationTilt: 0.0,
        lastUpdated: '10 mins ago',
        status: StationStatus.active,
        populationAtRisk: 3400,
      ),
      SensorStation(
        id: 'ST-DARJ',
        name: 'Darjeeling Mall Ridge',
        region: 'Darjeeling District',
        state: 'West Bengal',
        lat: 27.041,
        lng: 88.2663,
        elevation: 2045,
        slopeAngle: 41,
        dailyRainfall: 122,
        cumulative7dRainfall: 310,
        soilMoisture: const SoilMoisture(depth0_7cm: 93, depth7_28cm: 89, depth28_100cm: 84),
        poreWaterPressure: 16.1,
        soilType: 'Darjeeling Gneiss',
        ndvi: 0.35,
        vibrationTilt: 4.5,
        lastUpdated: '1 min ago',
        status: StationStatus.critical,
        populationAtRisk: 14500,
      ),
      SensorStation(
        id: 'ST-SHIM',
        name: 'Shimla Highway Monitor',
        region: 'Shimla District',
        state: 'Himachal Pradesh',
        lat: 31.1048,
        lng: 77.1734,
        elevation: 2276,
        slopeAngle: 33,
        dailyRainfall: 64,
        cumulative7dRainfall: 140,
        soilMoisture: const SoilMoisture(depth0_7cm: 68, depth7_28cm: 62, depth28_100cm: 58),
        poreWaterPressure: 7.1,
        soilType: 'Phyllite & Schist',
        ndvi: 0.55,
        vibrationTilt: 1.1,
        lastUpdated: '4 mins ago',
        status: StationStatus.warning,
        populationAtRisk: 11200,
      ),
    ];

    for (var st in rawStations) {
      final res = TerraGuardAIEngine.calculateRisk(PredictionParameters(
        slopeAngle: st.slopeAngle,
        dailyRainfall: st.dailyRainfall,
        cumulative7dRainfall: st.cumulative7dRainfall,
        soilMoisture0_7cm: st.soilMoisture.depth0_7cm,
        soilMoisture7_28cm: st.soilMoisture.depth7_28cm,
        soilMoisture28_100cm: st.soilMoisture.depth28_100cm,
        porePressure: st.poreWaterPressure,
        ndvi: st.ndvi,
        elevation: st.elevation,
        vibrationTilt: st.vibrationTilt,
      ));
      st.riskScore = res.riskScore;
      st.threatLevel = res.threatLevel;
    }

    return rawStations;
  }

  static List<StateHistoricalData> getHistoricalData() {
    return const [
      StateHistoricalData(state: 'Eastern Himalayas General', events: 5996, deaths: 142, roadBlockades: 480, avgRiskScore: 82),
      StateHistoricalData(state: 'Arunachal Pradesh', events: 2933, deaths: 68, roadBlockades: 245, avgRiskScore: 79),
      StateHistoricalData(state: 'Nagaland & Manipur', events: 2527, deaths: 54, roadBlockades: 198, avgRiskScore: 76),
      StateHistoricalData(state: 'Mizoram & Tripura', events: 2136, deaths: 41, roadBlockades: 162, avgRiskScore: 71),
      StateHistoricalData(state: 'Meghalaya Plateau', events: 1602, deaths: 38, roadBlockades: 124, avgRiskScore: 77),
      StateHistoricalData(state: 'Assam (Dima Hasao)', events: 1539, deaths: 32, roadBlockades: 110, avgRiskScore: 73),
      StateHistoricalData(state: 'Sikkim & West Bengal', events: 859, deaths: 29, roadBlockades: 88, avgRiskScore: 85),
      StateHistoricalData(state: 'Himachal & Western', events: 44, deaths: 8, roadBlockades: 14, avgRiskScore: 62),
    ];
  }

  static List<MonthlyTrend> getMonthlyTrends() {
    return const [
      MonthlyTrend(month: 'Jan', rainfall: 15, landslides: 0, avgSoilSat: 22),
      MonthlyTrend(month: 'Feb', rainfall: 25, landslides: 0, avgSoilSat: 25),
      MonthlyTrend(month: 'Mar', rainfall: 55, landslides: 1, avgSoilSat: 38),
      MonthlyTrend(month: 'Apr', rainfall: 110, landslides: 3, avgSoilSat: 54),
      MonthlyTrend(month: 'May', rainfall: 240, landslides: 8, avgSoilSat: 72),
      MonthlyTrend(month: 'Jun', rainfall: 480, landslides: 24, avgSoilSat: 91),
      MonthlyTrend(month: 'Jul', rainfall: 590, landslides: 32, avgSoilSat: 96),
      MonthlyTrend(month: 'Aug', rainfall: 510, landslides: 28, avgSoilSat: 94),
      MonthlyTrend(month: 'Sep', rainfall: 320, landslides: 14, avgSoilSat: 84),
      MonthlyTrend(month: 'Oct', rainfall: 140, landslides: 4, avgSoilSat: 61),
      MonthlyTrend(month: 'Nov', rainfall: 35, landslides: 1, avgSoilSat: 35),
      MonthlyTrend(month: 'Dec', rainfall: 18, landslides: 0, avgSoilSat: 24),
    ];
  }

  static List<CitizenReport> getInitialCitizenReports() {
    return [
      CitizenReport(
        id: 'REP-101',
        reporterName: 'Vikram Gurung',
        reporterRole: 'Field Officer',
        locationName: 'NH-10 Sevoke Road Corridor (km 24)',
        state: 'Sikkim',
        lat: 26.892,
        lng: 88.451,
        hazardType: 'Tension Cracks',
        severity: 'Severe',
        photoUrl: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=600',
        description: '35-meter long longitudinal tension cracks observed along outer shoulder after 120mm rain.',
        status: 'Verified',
        timestamp: '25 mins ago',
      ),
      CitizenReport(
        id: 'REP-102',
        reporterName: 'Anjelica Sangma',
        reporterRole: 'Citizen',
        locationName: 'Cherrapunji Bypass Road slope',
        state: 'Meghalaya',
        lat: 25.301,
        lng: 91.735,
        hazardType: 'Falling Rocks',
        severity: 'High',
        photoUrl: 'https://images.unsplash.com/photo-1508873696983-2df515122519?w=600',
        description: 'Minor rockfalls and debris spilling onto single lane road. Muddy water seepage from base.',
        status: 'Rescue Dispatched',
        timestamp: '1 hour ago',
      ),
      CitizenReport(
        id: 'REP-103',
        reporterName: 'Ramu Debbarma',
        reporterRole: 'Disaster Warden',
        locationName: 'Jampui Hills Ridge trail',
        state: 'Tripura',
        lat: 23.921,
        lng: 92.285,
        hazardType: 'Tree Leaning',
        severity: 'Moderate',
        photoUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=600',
        description: 'Pine trees tilted at 25-degree angles on soil slope. Possible slow soil creep.',
        status: 'Pending',
        timestamp: '3 hours ago',
      ),
    ];
  }

  static List<EarlyWarningAlert> getInitialEarlyWarnings() {
    return const [
      EarlyWarningAlert(
        id: 'ALT-9901',
        stationId: 'ST-CHER',
        locationName: 'Cherrapunji East Khasi Ridge Zone',
        threatLevel: ThreatLevel.emergency,
        riskScore: 94,
        issuedAt: '12 mins ago',
        channels: ['SMS', 'Push Notification', 'Sirens', 'Dashboard Broadcast'],
        affectedPopulation: 8450,
        actionProtocol: 'Immediate Mass Evacuation Protocol activated for downhill villages. Traffic halted on SH-5.',
      ),
      EarlyWarningAlert(
        id: 'ALT-9902',
        stationId: 'ST-DARJ',
        locationName: 'Darjeeling Mall Ridge Slope',
        threatLevel: ThreatLevel.emergency,
        riskScore: 91,
        issuedAt: '28 mins ago',
        channels: ['SMS', 'Push Notification', 'Dashboard Broadcast'],
        affectedPopulation: 14500,
        actionProtocol: 'NDRF Rescue Battalions pre-positioned. Road blockades deployed at Ghum intersection.',
      ),
      EarlyWarningAlert(
        id: 'ALT-9903',
        stationId: 'ST-HAFL',
        locationName: 'Haflong Railway Slope Zone',
        threatLevel: ThreatLevel.emergency,
        riskScore: 89,
        issuedAt: '45 mins ago',
        channels: ['SMS', 'Push Notification', 'Dashboard Broadcast'],
        affectedPopulation: 8900,
        actionProtocol: 'Train operations suspended on Lumding-Badarpur hill section due to high debris risk.',
      ),
    ];
  }
}

// ==========================================
// MAIN APP SCREEN & NAVIGATION
// ==========================================

class TerraGuardMainScreen extends StatefulWidget {
  const TerraGuardMainScreen({super.key});

  @override
  State<TerraGuardMainScreen> createState() => _TerraGuardMainScreenState();
}

class _TerraGuardMainScreenState extends State<TerraGuardMainScreen> {
  int _currentIndex = 0;
  List<SensorStation> _stations = [];
  SensorStation? _selectedStation;
  List<CitizenReport> _citizenReports = [];
  List<EarlyWarningAlert> _earlyWarnings = [];
  String _selectedState = 'All 8 States';

  @override
  void initState() {
    super.initState();
    _stations = TerraGuardRepository.getInitialStations();
    _citizenReports = TerraGuardRepository.getInitialCitizenReports();
    _earlyWarnings = TerraGuardRepository.getInitialEarlyWarnings();
  }

  void _addNewReport(CitizenReport report) {
    setState(() {
      _citizenReports.insert(0, report);
    });
  }

  void _triggerEmergencySiren(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFEF4444),
        content: const Row(
          children: [
            Icon(Icons.warning, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '🚨 Emergency Broadcast Sirens Activated for High Risk Zones!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final criticalCount = _stations.where((s) => s.status == StationStatus.critical).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        elevation: 2,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TerraGuard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'AI GIS Landslide Warning System',
                  style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Chip(
              backgroundColor: const Color(0xFFEF4444).withOpacity(0.2),
              side: const BorderSide(color: Color(0xFFEF4444), width: 0.5),
              avatar: const CircleAvatar(
                backgroundColor: Color(0xFFEF4444),
                radius: 4,
              ),
              label: Text(
                '$criticalCount CRITICAL',
                style: const TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_alert, color: Color(0xFFEF4444)),
            tooltip: 'Trigger Emergency Siren',
            onPressed: () => _triggerEmergencySiren(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          MapDashboardView(stations: _stations),
          const AISimulatorView(),
          TelemetryFeedView(stations: _stations),
          AlertHubView(alerts: _earlyWarnings, onTriggerSiren: () => _triggerEmergencySiren(context)),
          HazardReportView(reports: _citizenReports, onReportSubmitted: _addNewReport),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF0D1322),
        selectedItemColor: const Color(0xFF06B6D4),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map & Dash'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'AI Predict'),
          BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'Sensors'),
          BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.report_problem), label: 'Reports'),
        ],
      ),
    );
  }
}

// ==========================================
// 1. MAP & DASHBOARD VIEW
// ==========================================

class MapDashboardView extends StatefulWidget {
  final List<SensorStation> stations;
  const MapDashboardView({super.key, required this.stations});

  @override
  State<MapDashboardView> createState() => _MapDashboardViewState();
}

class _MapDashboardViewState extends State<MapDashboardView> {
  String _selectedFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final stations = widget.stations;
    final totalPopulation = stations.fold<int>(0, (sum, s) => sum + s.populationAtRisk);
    final criticalCount = stations.where((s) => s.status == StationStatus.critical).length;
    final warningCount = stations.where((s) => s.status == StationStatus.warning).length;

    List<SensorStation> filteredStations = stations;
    if (_selectedFilter == 'CRITICAL') {
      filteredStations = stations.where((s) => s.status == StationStatus.critical).toList();
    } else if (_selectedFilter == 'WARNING') {
      filteredStations = stations.where((s) => s.status == StationStatus.warning).toList();
    } else if (_selectedFilter == 'ACTIVE') {
      filteredStations = stations.where((s) => s.status == StationStatus.active).toList();
    }

    final historical = TerraGuardRepository.getHistoricalData();
    final monthly = TerraGuardRepository.getMonthlyTrends();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Metric Header Grid
          Row(
            children: [
              _buildKpiCard('Total Stations', '${stations.length}', Icons.sensors, const Color(0xFF06B6D4)),
              const SizedBox(width: 8),
              _buildKpiCard('Critical Risk', '$criticalCount', Icons.gpp_maybe, const Color(0xFFEF4444)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildKpiCard('Warning Zones', '$warningCount', Icons.warning_amber, const Color(0xFFF97316)),
              const SizedBox(width: 8),
              _buildKpiCard('At Risk Pop.', '${(totalPopulation / 1000).toStringAsFixed(1)}k', Icons.people, const Color(0xFF10B981)),
            ],
          ),
          const SizedBox(height: 16),

          // Interactive GIS Map Representation Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF06B6D4).withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.explore, color: Color(0xFF06B6D4)),
                    const SizedBox(width: 8),
                    const Text(
                      'Live GIS Himalayan Spatial Network',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('16 IoT Nodes Active', style: TextStyle(color: Color(0xFF10B981), fontSize: 10)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Monitoring slope instability across Sikkim, Meghalaya, Arunachal Pradesh, Mizoram, Nagaland, Assam, Tripura, West Bengal & Himachal.',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Filter Chips Bar
          Row(
            children: [
              const Text('Filter Stations: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
              const SizedBox(width: 8),
              _buildFilterChip('ALL'),
              const SizedBox(width: 6),
              _buildFilterChip('CRITICAL'),
              const SizedBox(width: 6),
              _buildFilterChip('WARNING'),
              const SizedBox(width: 6),
              _buildFilterChip('ACTIVE'),
            ],
          ),
          const SizedBox(height: 12),

          // Sensor Station Cards List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredStations.length,
            itemBuilder: (context, index) {
              final st = filteredStations[index];
              return _buildStationCard(context, st);
            },
          ),
          const SizedBox(height: 20),

          // Historical Landslide Data Section
          const Text(
            'State-wise Historical Landslide Impact',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: historical.map((h) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(h.state, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('${h.events} events', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('${h.deaths} fatalities', style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF06B6D4).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Avg Risk ${h.avgRiskScore}', style: const TextStyle(color: Color(0xFF06B6D4), fontSize: 10)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Monthly Seasonal Trends Section
          const Text(
            'Monsoon Seasonal Rainfall vs Landslides',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: monthly.map((m) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 35,
                        child: Text(m.month, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: (m.rainfall / 600).clamp(0.0, 1.0),
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF06B6D4),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 70,
                        child: Text('${m.rainfall.toInt()} mm', style: const TextStyle(color: Color(0xFF06B6D4), fontSize: 10)),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text('${m.landslides} slides', style: TextStyle(color: m.landslides > 10 ? const Color(0xFFEF4444) : Colors.grey, fontSize: 10, fontWeight: m.landslides > 10 ? FontWeight.bold : FontWeight.normal)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF06B6D4) : const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStationCard(BuildContext context, SensorStation st) {
    Color statusColor = const Color(0xFF10B981);
    if (st.status == StationStatus.critical) statusColor = const Color(0xFFEF4444);
    if (st.status == StationStatus.warning) statusColor = const Color(0xFFF97316);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(st.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    Text('${st.region}, ${st.state}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  st.status.name.toUpperCase(),
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniMetric('Slope', '${st.slopeAngle}°'),
              _buildMiniMetric('Rain 24h', '${st.dailyRainfall}mm'),
              _buildMiniMetric('Soil Sat.', '${st.soilMoisture.depth0_7cm}%'),
              _buildMiniMetric('Pore Press.', '${st.poreWaterPressure} kPa'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('AI Risk Score: ', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('${st.riskScore}/100', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: st.riskScore / 100.0,
                    backgroundColor: Colors.white10,
                    color: statusColor,
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () => _showStationDetailsModal(context, st),
              icon: const Icon(Icons.analytics, size: 14, color: Color(0xFF06B6D4)),
              label: const Text('View Full Telemetry & AI Model', style: TextStyle(fontSize: 11, color: Color(0xFF06B6D4))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String label, String val) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
      ],
    );
  }

  void _showStationDetailsModal(BuildContext context, SensorStation st) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(st.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.white10),
              Text('Location: Lat ${st.lat}, Lng ${st.lng} | Elevation: ${st.elevation.toInt()}m', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 8),
              Text('Soil Type: ${st.soilType}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 12),
              const Text('Geotechnical Parameters:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF06B6D4))),
              const SizedBox(height: 6),
              Text('• Soil Moisture (0-7cm): ${st.soilMoisture.depth0_7cm}%'),
              Text('• Soil Moisture (7-28cm): ${st.soilMoisture.depth7_28cm}%'),
              Text('• Soil Moisture (28-100cm): ${st.soilMoisture.depth28_100cm}%'),
              Text('• Pore Water Pressure: ${st.poreWaterPressure} kPa'),
              Text('• Structural Tilt / Vibration Creep: ${st.vibrationTilt} mm/h'),
              Text('• Vegetation Index (NDVI): ${st.ndvi}'),
              Text('• Population at Risk: ${st.populationAtRisk} citizens'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================
// 2. AI PREDICTOR & SIMULATOR VIEW
// ==========================================

class AISimulatorView extends StatefulWidget {
  const AISimulatorView({super.key});

  @override
  State<AISimulatorView> createState() => _AISimulatorViewState();
}

class _AISimulatorViewState extends State<AISimulatorView> {
  final PredictionParameters _params = PredictionParameters(
    slopeAngle: 38.0,
    dailyRainfall: 115.0,
    cumulative7dRainfall: 290.0,
    soilMoisture0_7cm: 91.0,
    soilMoisture7_28cm: 87.0,
    soilMoisture28_100cm: 82.0,
    porePressure: 14.2,
    ndvi: 0.42,
    elevation: 1650.0,
    vibrationTilt: 3.2,
  );

  void _applyPreset(String presetName) {
    setState(() {
      if (presetName == 'Severe Monsoon') {
        _params.slopeAngle = 42;
        _params.dailyRainfall = 165;
        _params.cumulative7dRainfall = 380;
        _params.soilMoisture0_7cm = 96;
        _params.soilMoisture7_28cm = 92;
        _params.soilMoisture28_100cm = 88;
        _params.porePressure = 18.5;
        _params.ndvi = 0.31;
        _params.vibrationTilt = 4.8;
      } else if (presetName == 'High Creep') {
        _params.slopeAngle = 36;
        _params.dailyRainfall = 78;
        _params.cumulative7dRainfall = 210;
        _params.soilMoisture0_7cm = 88;
        _params.soilMoisture7_28cm = 84;
        _params.soilMoisture28_100cm = 79;
        _params.porePressure = 11.2;
        _params.ndvi = 0.45;
        _params.vibrationTilt = 2.1;
      } else if (presetName == 'Moderate Advisory') {
        _params.slopeAngle = 29;
        _params.dailyRainfall = 42;
        _params.cumulative7dRainfall = 110;
        _params.soilMoisture0_7cm = 65;
        _params.soilMoisture7_28cm = 58;
        _params.soilMoisture28_100cm = 52;
        _params.porePressure = 5.4;
        _params.ndvi = 0.62;
        _params.vibrationTilt = 0.4;
      } else if (presetName == 'Normal Baseline') {
        _params.slopeAngle = 22;
        _params.dailyRainfall = 8;
        _params.cumulative7dRainfall = 25;
        _params.soilMoisture0_7cm = 32;
        _params.soilMoisture7_28cm = 29;
        _params.soilMoisture28_100cm = 27;
        _params.porePressure = 1.2;
        _params.ndvi = 0.78;
        _params.vibrationTilt = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = NimicAIEngine.calculateRisk(_params);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF06B6D4).withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.psychology, color: Color(0xFF06B6D4), size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nimic Physics-Informed AI Simulator',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                      ),
                      Text(
                        'Combines Infinite Slope Stability Physics & Ensemble Gradient Boosting Model',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Preset Selection Chips
          const Text('Simulation Presets:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildPresetChip('Severe Monsoon'),
              _buildPresetChip('High Creep'),
              _buildPresetChip('Moderate Advisory'),
              _buildPresetChip('Normal Baseline'),
            ],
          ),
          const SizedBox(height: 16),

          // Real-time AI Prediction Gauge Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: result.threatColor, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: result.threatColor.withOpacity(0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('LIVE AI RISK SCORE', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${result.riskScore}',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: result.threatColor),
                            ),
                            const Text('/100', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: result.threatColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: result.threatColor),
                      ),
                      child: Text(
                        result.threatLevel.name.toUpperCase(),
                        style: TextStyle(color: result.threatColor, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Slide Probability: ${result.probabilityPercentage}%', style: const TextStyle(fontSize: 11, color: Colors.white)),
                    Text(result.estimatedTimeToSlide, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: result.threatColor)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Parameter Sliders Card
          const Text('Geotechnical Parameters Controls', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                _buildSlider(
                  label: 'Slope Inclination Angle',
                  value: _params.slopeAngle,
                  unit: '°',
                  min: 0,
                  max: 60,
                  onChanged: (v) => setState(() => _params.slopeAngle = v),
                ),
                _buildSlider(
                  label: '24h Rain Intensity',
                  value: _params.dailyRainfall,
                  unit: ' mm/day',
                  min: 0,
                  max: 300,
                  onChanged: (v) => setState(() => _params.dailyRainfall = v),
                ),
                _buildSlider(
                  label: '7-Day Cumulative Rain',
                  value: _params.cumulative7dRainfall,
                  unit: ' mm',
                  min: 0,
                  max: 600,
                  onChanged: (v) => setState(() => _params.cumulative7dRainfall = v),
                ),
                _buildSlider(
                  label: 'Soil Saturation (0-7cm)',
                  value: _params.soilMoisture0_7cm,
                  unit: '%',
                  min: 0,
                  max: 100,
                  onChanged: (v) => setState(() => _params.soilMoisture0_7cm = v),
                ),
                _buildSlider(
                  label: 'Pore Water Pressure',
                  value: _params.porePressure,
                  unit: ' kPa',
                  min: 0,
                  max: 30,
                  onChanged: (v) => setState(() => _params.porePressure = v),
                ),
                _buildSlider(
                  label: 'Vegetation Cover (NDVI)',
                  value: _params.ndvi,
                  unit: '',
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  onChanged: (v) => setState(() => _params.ndvi = v),
                ),
                _buildSlider(
                  label: 'Structural Tilt / Creep',
                  value: _params.vibrationTilt,
                  unit: ' mm/h',
                  min: 0.0,
                  max: 10.0,
                  onChanged: (v) => setState(() => _params.vibrationTilt = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 6-Factor Contribution Breakdown
          const Text('6-Factor Risk Contribution Breakdown', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: result.factorBreakdown.map((f) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(f.feature, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white)),
                          Text('${f.contribution} / ${(f.weight).toInt()} pts', style: const TextStyle(fontSize: 10, color: Color(0xFF06B6D4))),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(f.description, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (f.contribution / f.weight).clamp(0.0, 1.0),
                          backgroundColor: Colors.white10,
                          color: const Color(0xFF06B6D4),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Recommended Action Protocols
          const Text('AI Action Protocol Recommendations', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: result.recommendedActions.map((action) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(action, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label) {
    return ActionChip(
      backgroundColor: const Color(0xFF1F2937),
      side: const BorderSide(color: Color(0xFF06B6D4), width: 0.5),
      label: Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF06B6D4))),
      onPressed: () => _applyPreset(label),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required String unit,
    required double min,
    required double max,
    int? divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text('${value.toStringAsFixed(unit == '' ? 2 : 1)}$unit', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          activeColor: const Color(0xFF06B6D4),
          inactiveColor: Colors.white10,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ==========================================
// 3. IOT SENSORS TELEMETRY VIEW
// ==========================================

class TelemetryFeedView extends StatelessWidget {
  final List<SensorStation> stations;
  const TelemetryFeedView({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'IoT Station Telemetry Stream',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Real-time deep profile soil moisture, pore pressure & structural vibration telemetry',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 14),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stations.length,
            itemBuilder: (context, index) {
              final st = stations[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.sensors, color: Color(0xFF06B6D4), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(st.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                        ),
                        Text(st.lastUpdated, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Soil Moisture Profile Saturation:', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    const SizedBox(height: 6),
                    _buildMoistureBar('0-7 cm', st.soilMoisture.depth0_7cm),
                    _buildMoistureBar('7-28 cm', st.soilMoisture.depth7_28cm),
                    _buildMoistureBar('28-100 cm', st.soilMoisture.depth28_100cm),
                    const Divider(color: Colors.white10, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pore Pressure: ${st.poreWaterPressure} kPa', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                        Text('Vibration Tilt: ${st.vibrationTilt} mm/h', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                        Text('NDVI: ${st.ndvi}', style: const TextStyle(fontSize: 11, color: Color(0xFF10B981))),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMoistureBar(String depthLabel, double satValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(depthLabel, style: const TextStyle(fontSize: 10, color: Colors.grey))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: satValue / 100.0,
                backgroundColor: Colors.white10,
                color: satValue > 85 ? const Color(0xFFEF4444) : const Color(0xFF06B6D4),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(width: 35, child: Text('${satValue.toInt()}%', style: const TextStyle(fontSize: 10, color: Colors.white))),
        ],
      ),
    );
  }
}

// ==========================================
// 4. ALERTS HUB VIEW
// ==========================================

class AlertHubView extends StatelessWidget {
  final List<EarlyWarningAlert> alerts;
  final VoidCallback onTriggerSiren;

  const AlertHubView({super.key, required this.alerts, required this.onTriggerSiren});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Early Warning Alert Hub', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('Active emergency notifications & Siren dispatch system', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                onPressed: onTriggerSiren,
                icon: const Icon(Icons.volume_up, size: 16),
                label: const Text('DISPATCH SIRENS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alt = alerts[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(alt.threatLevel.name.toUpperCase(), style: const TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(alt.locationName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white))),
                        Text(alt.issuedAt, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Affected Citizens: ${alt.affectedPopulation} residents', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                    const SizedBox(height: 6),
                    Text('Protocol: ${alt.actionProtocol}', style: const TextStyle(fontSize: 11, color: Color(0xFFF97316))),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 4,
                      children: alt.channels.map((ch) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(ch, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 5. FIELD HAZARD REPORTING VIEW
// ==========================================

class HazardReportView extends StatefulWidget {
  final List<CitizenReport> reports;
  final ValueChanged<CitizenReport> onReportSubmitted;

  const HazardReportView({super.key, required this.reports, required this.onReportSubmitted});

  @override
  State<HazardReportView> createState() => _HazardReportViewState();
}

class _HazardReportViewState extends State<HazardReportView> {
  void _openSubmitReportDialog(BuildContext context) {
    final locationController = TextEditingController();
    final descriptionController = TextEditingController();
    final reporterController = TextEditingController(text: 'Citizen User');
    String state = 'Sikkim';
    String hazardType = 'Tension Cracks';
    String severity = 'High';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Submit Field Hazard Incident Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location Name / Corridor', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Hazard Observations / Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: hazardType,
                      items: ['Tension Cracks', 'Falling Rocks', 'Tree Leaning', 'Mudflow Seepage']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (v) => hazardType = v!,
                      decoration: const InputDecoration(labelText: 'Hazard Type'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: severity,
                      items: ['Low', 'Moderate', 'High', 'Severe']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (v) => severity = v!,
                      decoration: const InputDecoration(labelText: 'Severity'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF06B6D4)),
                  onPressed: () {
                    if (locationController.text.isEmpty) return;
                    final newReport = CitizenReport(
                      id: 'REP-${100 + widget.reports.length + 1}',
                      reporterName: reporterController.text,
                      reporterRole: 'Citizen',
                      locationName: locationController.text,
                      state: state,
                      lat: 26.9,
                      lng: 88.5,
                      hazardType: hazardType,
                      severity: severity,
                      photoUrl: '',
                      description: descriptionController.text.isEmpty ? 'Observed slope degradation.' : descriptionController.text,
                      status: 'Pending Verification',
                      timestamp: 'Just now',
                    );
                    widget.onReportSubmitted(newReport);
                    Navigator.pop(context);
                  },
                  child: const Text('SUBMIT HAZARD REPORT', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Field Hazard Incident Reports', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Crowdsourced citizen & disaster warden hazard feed', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF06B6D4)),
                  onPressed: () => _openSubmitReportDialog(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('NEW REPORT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 14),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.reports.length,
              itemBuilder: (context, index) {
                final rep = widget.reports[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(rep.locationName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF06B6D4).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(rep.status, style: const TextStyle(color: Color(0xFF06B6D4), fontSize: 10)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text('By ${rep.reporterName} (${rep.reporterRole})', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          const SizedBox(width: 8),
                          Text('• ${rep.timestamp}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xFFF97316).withOpacity(0.2),
                            label: Text(rep.hazardType, style: const TextStyle(fontSize: 10, color: Color(0xFFF97316))),
                          ),
                          const SizedBox(width: 6),
                          Chip(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xFFEF4444).withOpacity(0.2),
                            label: Text(rep.severity, style: const TextStyle(fontSize: 10, color: Color(0xFFEF4444))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(rep.description, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

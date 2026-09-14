# 🏔️ TerraGuard AI | All-Models Landslide Early Warning, .NET MAUI & Firebase System

[![React](https://img.shields.io/badge/React-19.x-blue.svg)](https://reactjs.org/)
[![.NET MAUI](https://img.shields.io/badge/.NET_MAUI-8.0-purple.svg)](https://dotnet.microsoft.com/apps/maui)
[![Firebase](https://img.shields.io/badge/Firebase-Realtime_&_FCM-orange.svg)](https://firebase.google.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B.svg)](https://flutter.dev/)
[![TailwindCSS](https://img.shields.io/badge/TailwindCSS-3.x-38B2AC.svg)](https://tailwindcss.com/)
[![Leaflet GIS](https://img.shields.io/badge/Leaflet_GIS-1.9-green.svg)](https://leafletjs.com/)
[![Dataset](https://img.shields.io/badge/Dataset-17%2C921_Events-red.svg)](#-ingested-landslide-dataset-17921-records)
[![License](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

**TerraGuard AI** is an end-to-end, multi-sensor **All-Models machine learning system**, **.NET MAUI native cross-platform application**, and **Firebase real-time infrastructure** for real-time landslide susceptibility modeling, IoT sensor monitoring, multi-model consensus risk forecasting, and emergency alert dissemination across the **North-Eastern Indian and Himalayan mountain regions**.

---

## 📁 Repository Directory Layout

```
nimic_landslide_ai_system/
├── dataset/
│   ├── landslide_dataset.json   # 17,921 raw extracted landslide event records (Lat, Lon, Elev, Slope)
│   └── landslide_summary.json   # Spatial cluster summary & regional breakdown
├── web_app/                      # React + Vite + Leaflet GIS + Tailwind CSS + Firebase Web App
│   ├── src/
│   │   ├── components/          # AISimulatorPanel, GISMapDashboard, SOSRescueModal, AlertHub, etc.
│   │   ├── services/            # Firebase SDK (Firestore, Storage, FCM Push Messaging)
│   │   ├── utils/               # All-Models TerraGuard AI Engine (PINN, XGBoost, CNN-LSTM, ViT, HSI, Ensemble), i18n
│   │   └── data/                # Ingested dataset JSONs
│   ├── package.json
│   └── vite.config.ts
├── maui_app/                     # .NET MAUI (C# / XAML) Native Cross-Platform Application
│   ├── TerraGuard.Maui.csproj   # Targets Android, iOS, Windows, MacCatalyst
│   ├── Models/                  # SensorStation.cs, PredictionParameters.cs, SOSDistressRequest.cs
│   ├── Services/                # TerraGuardAIEngine.cs, FirebaseService.cs
│   ├── ViewModels/              # MainViewModel.cs (MVVM CommunityToolkit)
│   ├── Views/                   # MainPage.xaml & MainPage.xaml.cs
│   ├── google-services.json     # Android FCM configuration template
│   └── GoogleService-Info.plist # iOS FCM configuration template
├── mobile_app/                   # Cross-Platform Flutter Mobile Application
│   ├── lib/
│   │   └── main.dart            # Complete Flutter app with 5 core views & TerraGuard AI engine
│   └── pubspec.yaml
└── README.md
```

---

## 📊 Ingested Landslide Dataset (17,921 Records)

The system is trained and benchmarked against **17,921 real-world historical landslide events** extracted from multi-source geotechnical PDF reports across **8 North-Eastern & Himalayan states**:

| Region / State | Total Events Ingested | Risk Index | High Risk Corridors |
| :--- | :---: | :---: | :--- |
| **Eastern Himalayas General** | **5,996** | `CRITICAL (82)` | Siliguri Corridor, Teesta Valley |
| **Arunachal Pradesh** | **2,933** | `HIGH (79)` | Tawang Pass, Bhalukpong Corridor |
| **Nagaland & Manipur** | **2,527** | `HIGH (76)` | Kohima Ridge, Imphal-Dimapur Highway |
| **Mizoram & Tripura** | **2,136** | `MODERATE (71)` | Lunglei Highway, Jampui Ridge |
| **Meghalaya Plateau** | **1,602** | `CRITICAL (77)` | Cherrapunji Escarpment, NH-44 |
| **Assam (Dima Hasao)** | **1,539** | `HIGH (73)` | Haflong Hill Railway Route |
| **Sikkim & West Bengal** | **859** | `CRITICAL (85)` | Gangtok Ridge, Darjeeling Mall |
| **Himachal & Western** | **44** | `MODERATE (62)` | Shimla National Highway |

---

## 🔬 TerraGuard All-Models AI Inference Architecture

The risk prediction engine (`TerraGuardAIEngine`) integrates **5 specialized AI/Physics models** into a **Multi-Model Weighted Consensus Ensemble**:

1. **PINN (Physics-Informed Neural Network)**: Mohr-Coulomb shear stress vs. shear strength along infinite slope failure surfaces (Factor of Safety FoS).
2. **XGBoost / Random Forest Classifier**: Decision tree ensemble trained on multi-depth soil saturation (0-7cm, 7-28cm, 28-100cm) and 7-day cumulative rainfall.
3. **CNN-LSTM Temporal Sequence Model**: Deep neural network tracking 24-hour creep rate, tilt displacement velocity, and pore water dynamics.
4. **Vision Transformer (ViT) Remote Sensing**: Earth observation model calculating NDVI vegetation root cohesion and terrain elevation curvature.
5. **Hydrological Slope Infiltration (HSI)**: Subsurface hydrodynamics modeling saturation front propagation and hydraulic head pressure.
6. **All Models Ensemble Consensus**: Blends outputs across all 5 models with dynamic confidence weighting, variance metrics, and inter-model agreement scoring.

---

## ⚡ Key Features & Software Stack

1. **.NET MAUI Native Cross-Platform App**:
   - Single C#/XAML codebase (`maui_app/`) running natively on Android, iOS, Windows, and macOS.
   - Built with MVVM architecture, CommunityToolkit.Mvvm, and native device capabilities (GPS Geolocation, Haptics, Camera, Audio Siren).

2. **Firebase Realtime Backend**:
   - **Firebase Realtime Database / Firestore**: Streaming live IoT sensor station telemetry across web and MAUI mobile clients.
   - **Firebase Cloud Messaging (FCM)**: Emergency push alert broadcast dispatcher (`google-services.json` & `GoogleService-Info.plist`).
   - **Firebase Storage & Auth**: Citizen hazard photo uploads and user authentication.

3. **1-Tap SOS Emergency Rescue Suite**:
   - Immediate GPS location transmission, emergency location audio siren, relief shelter routing, and direct dialing to NDRF (1078), Police (112), and Disaster Management (1070).

---

## 🚀 Quickstart & Installation

### 1. Running the .NET MAUI Application

```bash
# Navigate to MAUI app directory
cd maui_app

# Build and run for Android / Windows / iOS
dotnet build -f net8.0-android
dotnet build -f net8.0-windows10.0.19041.0
```

### 2. Running the Web Application (PWA / Mobile App)

```bash
cd web_app
npm install
npm run dev
```

Open `http://localhost:5173/` in your browser.

### 3. Building the Web Application for Production

```bash
cd web_app
npm run build
```

---

## 🛡️ License

This project is licensed under the MIT License - see the `LICENSE` file for details.

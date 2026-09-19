import 'package:flutter/material.dart';

import 'offline/field_report_capture_service.dart';
import 'offline/offline_hazard_report.dart';
import 'offline/offline_hazard_report_page.dart';
import 'offline/offline_report_store.dart';
import 'offline/offline_reports_page.dart';
import 'offline/offline_sync_manager.dart';
import 'offline/terraguard_http_sync_api.dart';
import 'offline/terraguard_offline_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final api = TerraGuardHttpSyncApi(
    reportsEndpoint: Uri.parse('https://example.com/api/terraguard/reports'),
    accessToken: () async => null,
  );

  final services = TerraGuardOfflineServices(api: api);
  await services.start();

  runApp(TerraGuardApp(offlineServices: services));
}

class TerraGuardApp extends StatelessWidget {
  final TerraGuardOfflineServices offlineServices;

  const TerraGuardApp({super.key, required this.offlineServices});

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
      home: TerraGuardMainScreen(offlineServices: offlineServices),
    );
  }
}

class TerraGuardMainScreen extends StatefulWidget {
  final TerraGuardOfflineServices offlineServices;

  const TerraGuardMainScreen({super.key, required this.offlineServices});

  @override
  State<TerraGuardMainScreen> createState() => _TerraGuardMainScreenState();
}

class _TerraGuardMainScreenState extends State<TerraGuardMainScreen> {
  int _currentIndex = 0;
  bool _online = true;

  @override
  void initState() {
    super.initState();
    _online = true;
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.offlineServices.store;
    final sync = widget.offlineServices.sync;
    final captureService = FieldReportCaptureService(syncManager: sync);

    final screens = [
      const Center(child: Text('Map Dashboard')), 
      const Center(child: Text('AI Predict')), 
      const Center(child: Text('Sensors')), 
      const Center(child: Text('Alerts')), 
      OfflineHazardReportPage(
        captureService: captureService,
        onSaved: () => setState(() {}),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('TerraGuard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: OfflineStatusCard(
              store: store,
              online: _online,
            ),
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'AI'),
          BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'Sensors'),
          BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.report_problem), label: 'Reports'),
        ],
      ),
      floatingActionButton: _currentIndex == 4
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OfflineHazardReportPage(
                      captureService: captureService,
                      onSaved: () => setState(() {}),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add_alert),
            ),
    );
  }
}

// Keep the original TerraGuard dashboard classes intact below this point if needed.

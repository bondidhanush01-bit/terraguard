import 'package:flutter/material.dart';

import 'offline_hazard_report.dart';
import 'offline_report_store.dart';

class OfflineStatusCard extends StatelessWidget {
  final OfflineReportStore store;
  final bool online;

  const OfflineStatusCard({super.key, required this.store, required this.online});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: store.pendingCount(),
      builder: (context, snapshot) {
        final pending = snapshot.data ?? 0;
        return Card(
          child: ListTile(
            leading: Icon(online ? Icons.cloud_done : Icons.cloud_off,
                color: online ? Colors.green : Colors.orange),
            title: Text(online ? 'Online' : 'Offline mode'),
            subtitle: Text('$pending report${pending == 1 ? '' : 's'} pending sync'),
          ),
        );
      },
    );
  }
}

class OfflineReportsPage extends StatelessWidget {
  final OfflineReportStore store;

  const OfflineReportsPage({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Reports')),
      body: FutureBuilder<List<OfflineHazardReport>>(
        future: store.all(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final reports = snapshot.data!;
          if (reports.isEmpty) return const Center(child: Text('No field reports yet.'));
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return ListTile(
                leading: Icon(_icon(report.hazardType)),
                title: Text(report.hazardType.name),
                subtitle: Text('${report.latitude.toStringAsFixed(5)}, ${report.longitude.toStringAsFixed(5)}\n${report.capturedAt.toLocal()}'),
                isThreeLine: true,
                trailing: Chip(label: Text(report.status.name)),
              );
            },
          );
        },
      ),
    );
  }

  IconData _icon(HazardType type) => switch (type) {
        HazardType.landslide => Icons.terrain,
        HazardType.rockfall => Icons.landscape,
        HazardType.roadBlockage => Icons.block,
        HazardType.slopeFailure => Icons.warning_amber,
        HazardType.flood => Icons.water,
        HazardType.other => Icons.report_problem,
      };
}

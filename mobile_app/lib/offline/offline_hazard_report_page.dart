import 'package:flutter/material.dart';

import 'field_report_capture_service.dart';
import 'offline_hazard_report.dart';

/// Reusable production field-reporting screen. It saves locally before any API call.
class OfflineHazardReportPage extends StatefulWidget {
  final FieldReportCaptureService captureService;
  final VoidCallback? onSaved;

  const OfflineHazardReportPage({
    super.key,
    required this.captureService,
    this.onSaved,
  });

  @override
  State<OfflineHazardReportPage> createState() => _OfflineHazardReportPageState();
}

class _OfflineHazardReportPageState extends State<OfflineHazardReportPage> {
  HazardType _hazardType = HazardType.landslide;
  final _description = TextEditingController();
  bool _saving = false;
  String? _message;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _captureAndSave() async {
    setState(() {
      _saving = true;
      _message = null;
    });
    try {
      final captured = await widget.captureService.capture(
        hazardType: _hazardType,
        description: _description.text.trim().isEmpty ? null : _description.text.trim(),
      );
      if (!mounted) return;
      setState(() => _message = captured == null
          ? 'Capture cancelled.'
          : 'Saved locally. It will sync automatically when online.');
      if (captured != null) widget.onSaved?.call();
    } catch (error) {
      if (mounted) setState(() => _message = error.toString().replaceFirst('Bad state: ', ''));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Hazard')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Capture field evidence', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('The photo, GPS coordinates, timestamp, and report are saved on this device first.'),
          const SizedBox(height: 24),
          DropdownButtonFormField<HazardType>(
            value: _hazardType,
            decoration: const InputDecoration(labelText: 'Hazard type', border: OutlineInputBorder()),
            items: HazardType.values
                .map((type) => DropdownMenuItem(value: type, child: Text(_label(type))))
                .toList(),
            onChanged: (value) => setState(() => _hazardType = value ?? HazardType.other),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _description,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              hintText: 'Describe cracks, debris, blocked roads, or waterlogging…',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _saving ? null : _captureAndSave,
            icon: _saving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.camera_alt),
            label: Text(_saving ? 'Saving report…' : 'Take photo and save report'),
          ),
          if (_message != null) ...[
            const SizedBox(height: 16),
            Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ],
        ],
      ),
    );
  }

  String _label(HazardType type) => switch (type) {
        HazardType.roadBlockage => 'Road blockage',
        HazardType.slopeFailure => 'Slope failure',
        HazardType.rockfall => 'Rockfall',
        HazardType.flood => 'Flood / waterlogging',
        HazardType.landslide => 'Landslide',
        HazardType.other => 'Other hazard',
      };
}

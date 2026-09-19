import 'dart:convert';

import 'package:http/http.dart' as http;

import 'offline_hazard_report.dart';
import 'offline_sync_manager.dart';

/// Authenticated backend adapter. The endpoint and token are injected by the
/// host application; neither is stored in source code or bundled in the app.
class TerraGuardHttpSyncApi implements TerraGuardSyncApi {
  final Uri reportsEndpoint;
  final Future<String?> Function() accessToken;
  final http.Client client;

  TerraGuardHttpSyncApi({
    required this.reportsEndpoint,
    required this.accessToken,
    http.Client? client,
  }) : client = client ?? http.Client();

  @override
  Future<void> uploadReport(OfflineHazardReport report) async {
    final token = await accessToken();
    if (token == null || token.isEmpty) {
      throw StateError('Authentication is required before synchronizing reports.');
    }

    final request = http.MultipartRequest('POST', reportsEndpoint)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..fields['report_id'] = report.reportId
      ..fields['hazard_type'] = report.hazardType.name
      ..fields['description'] = report.description ?? ''
      ..fields['latitude'] = report.latitude.toString()
      ..fields['longitude'] = report.longitude.toString()
      ..fields['captured_at'] = report.capturedAt.toUtc().toIso8601String()
      ..fields['device_id'] = report.deviceId;

    final imagePath = report.imagePath;
    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    final response = await client.send(request);
    final body = await response.stream.bytesToString();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('Report upload failed (${response.statusCode}): ${_safeBody(body)}');
    }
  }

  String _safeBody(String body) {
    if (body.length <= 300) return body;
    try {
      final decoded = jsonDecode(body);
      return jsonEncode(decoded).substring(0, 300);
    } catch (_) {
      return body.substring(0, 300);
    }
  }
}

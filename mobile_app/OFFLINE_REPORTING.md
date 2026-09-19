# TerraGuard Mobile Offline Reporting Integration

This directory contains the production-oriented offline reporting foundation:

- `offline_hazard_report.dart`: report model and lifecycle states.
- `offline_report_store.dart`: durable SQLite queue.
- `offline_sync_manager.dart`: connectivity-triggered upload/retry coordinator.
- `field_report_capture_service.dart`: camera, GPS, timestamp, and local persistence.
- `offline_hazard_report_page.dart`: field reporting UI.

## Wiring into the existing app

Create the store and API adapter at application startup:

```dart
final store = OfflineReportStore();
final sync = OfflineSyncManager(
  store: store,
  api: TerraGuardApiSyncAdapter(),
);
await sync.start();
```

Then open the field-reporting screen from the existing Reports tab:

```dart
Navigator.of(context).push(MaterialPageRoute(
  builder: (_) => OfflineHazardReportPage(
    captureService: FieldReportCaptureService(syncManager: sync),
  ),
));
```

`TerraGuardApiSyncAdapter` must be implemented against the existing authenticated TerraGuard backend. No API key or endpoint is hardcoded in the mobile application.

## Platform permissions

For Android, add camera and fine/coarse location permissions to the generated Flutter manifest. For iOS, add `NSCameraUsageDescription`, `NSLocationWhenInUseUsageDescription`, and `NSPhotoLibraryUsageDescription` to the generated Runner `Info.plist`.

Run `flutter pub get` before building the app. Platform folders are not currently committed in this repository, so Flutter will generate them with `flutter create .` before these native permission entries are applied.

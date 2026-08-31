class AppConstants {
  static const String appName = 'Photobooth Platform';
  static const String appVersion = '1.0.0';

  // Default Session Settings
  static const int defaultCountdownSeconds = 3;
  static const List<int> presetPhotoCounts = [1, 3, 4, 6, 8];

  // Storage Keys
  static const String sessionsStorageKey = 'photobooth_sessions_v1';
  static const String activeSessionKey = 'photobooth_active_session_v1';

  // Quality Standards
  static const double targetAspectRatio = 4 / 3;
  static const int previewWidth = 1280;
  static const int previewHeight = 720;
}

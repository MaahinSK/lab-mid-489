class Constants {
  // API Configuration
  static const String baseUrl = 'https://labs.anontech.info/cse489/exm3/api.php';
  static const String apiKey = '22201384';

  // Map defaults (Bangladesh center)
  static const double defaultLat = 23.6850;
  static const double defaultLon = 90.3563;
  static const double defaultZoom = 7.0;

  // Database
  static const String dbName = 'landmarks.db';
  static const int dbVersion = 1;

  // Tables
  static const String landmarksTable = 'landmarks';
  static const String visitsTable = 'visits';
  static const String pendingVisitsTable = 'pending_visits';
}
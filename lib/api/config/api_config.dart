class ApiConfig {
  // Base configuration
  static const String baseUrl = 'http://14.225.207.58:9898/api/v1';
  static const int connectionTimeout = 30; // seconds

  // Default headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // API paths
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String profilePath = '/profile';
  static const String novelsPath = '/novels';
  static const String chaptersPath = '/chapters';
  static const String commentsPath = '/comments';
  static const String imagesPath = '/images';
  static const String genresPath = '/genres';
  static const String usersPath = '/users';
  static const String audioFilesPath = '/audio-files';
  static const String forgotPasswordPath = '/forgot-password';
  static const String verifyOtpPath = '/verify-otp';
  static const String resetPasswordPath = '/reset-password';
  static const String ratingPath = '/rates';
  static const String readingProgressPath = '/reading-progress';
  static const String achievementsPath = '/achievements';
  static const String leaderboardPath = '/leaderboard';
  static const String statisticsPath = '/statistics';
}
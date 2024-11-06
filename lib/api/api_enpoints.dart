import 'package:apptruyenonline/api/config/api_config.dart';

class ApiEndpoints {
  // Auth endpoints
  static String login = '${ApiConfig.baseUrl}${ApiConfig.loginPath}';
  static String register = '${ApiConfig.baseUrl}${ApiConfig.registerPath}';
  static String forgotPassword = '${ApiConfig.baseUrl}${ApiConfig.forgotPasswordPath}';
  static String verifyOtp = '${ApiConfig.baseUrl}${ApiConfig.verifyOtpPath}';
  static String resetPassword = '${ApiConfig.baseUrl}${ApiConfig.resetPasswordPath}';

  // User endpoints
  static String getUserProfile(String username) => '${ApiConfig.baseUrl}${ApiConfig.profilePath}/$username';
  static String getUserImages(int userId) => '${ApiConfig.baseUrl}${ApiConfig.imagesPath}/?userId=$userId';
  static String uploadUserImage(int userId) => '${ApiConfig.baseUrl}${ApiConfig.imagesPath}/upload?userId=$userId';
  static String updateUserLevel(int userId) => '${ApiConfig.baseUrl}${ApiConfig.usersPath}/$userId/level';

  // Novel endpoints
  static String getNovelDetail(String slug) => '${ApiConfig.baseUrl}${ApiConfig.novelsPath}/$slug';
  static String getTopReadNovels = '${ApiConfig.baseUrl}${ApiConfig.novelsPath}/top-read?page=0&size=10';
  static String getTrendingNovels = '${ApiConfig.baseUrl}${ApiConfig.novelsPath}/trending?page=0&size=100';
  static String getNewReleasedNovels = '${ApiConfig.baseUrl}${ApiConfig.novelsPath}/new-released?page=0&size=100';
  static String searchNovelsByAuthor(String authorName) =>
      '${ApiConfig.baseUrl}${ApiConfig.novelsPath}/search/by-author?authorName=$authorName';
  static String searchNovelsByTitle(String title) =>
      '${ApiConfig.baseUrl}${ApiConfig.novelsPath}/search/by-title?title=$title';

  // Reading endpoints
  static String saveReadingProgress = '${ApiConfig.baseUrl}${ApiConfig.readingProgressPath}';
  static String getReadingHistory(int userId) =>
      '${ApiConfig.baseUrl}${ApiConfig.readingProgressPath}/history/$userId';
  static String updateChapterProgress = '${ApiConfig.baseUrl}${ApiConfig.readingProgressPath}/update';

  // Interaction endpoints
  static String postComment = '${ApiConfig.baseUrl}${ApiConfig.commentsPath}/post-comment';
  static String getComments(String slug) => '${ApiConfig.baseUrl}${ApiConfig.commentsPath}/$slug';
  static String rateNovel(String slug) => '${ApiConfig.baseUrl}${ApiConfig.ratingPath}/$slug';
  static String likeNovel(String slug) => '${ApiConfig.baseUrl}${ApiConfig.novelsPath}/$slug/like';

  // Statistics endpoints
  static String getDailyStats = '${ApiConfig.baseUrl}${ApiConfig.statisticsPath}/daily';
  static String getMonthlyStats = '${ApiConfig.baseUrl}${ApiConfig.statisticsPath}/monthly';
  static String getLeaderboard = '${ApiConfig.baseUrl}${ApiConfig.leaderboardPath}';
}
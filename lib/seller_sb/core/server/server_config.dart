class ServerConstApis {
  // Base URL الجديد للـ Backend
  // static String baseAPI = 'http://localhost:8000/api';
  // static String baseAPI = 'http://localhost:8000/api';

  // للاستخدام على الأجهزة الحقيقية أو الإنتاج، قم بتغيير الـ URL
  // static String baseAPI = 'https://myadvertisement.shop/api';
  static String baseAPI = 'http://10.0.2.2:8000/api'; // للمحاكي Android

  static String version = '$baseAPI/version';
  static String register = '$baseAPI/trader/register';
  static String login = '$baseAPI/trader/login';
  static String logout = '$baseAPI/trader/logout';
  static String deleteAccount = '$baseAPI/trader/delete';
  static String getProfile = '$baseAPI/trader/get/profile';
  static String updateProfile = '$baseAPI/trader/update/profile';

  ///// wallet & points
  static String getWallet = '$baseAPI/get/wallet';
  static String getPoints = '$baseAPI/get/point';
  static String rechargeByCode = '$baseAPI/RechargeByCode';

  ///// category
  static String getStoresCategories = '$baseAPI/categories';

  ///// cities
  static String getCities = '$baseAPI/cities';

  ///// posts
  static String addPost = '$baseAPI/posts/create';
  static String deletePost = '$baseAPI/posts/delete';
  static String showPost = '$baseAPI/posts/mine';
  static String likeOrDislikePost = '$baseAPI/post';

  ///// ad
  static String addAdvertize = '$baseAPI/ads/create';
  static String showAdvertize = '$baseAPI/ads/mine';
  static String deleteAdvertize = '$baseAPI/ads/delete';
  static String updateAdStatus = '$baseAPI/trader/ads'; // + /{id}/status
  static String getScheduledAds = '$baseAPI/trader/ads/scheduled';
  static String getExpiredAds = '$baseAPI/trader/ads/expired';
  static String renewAd = '$baseAPI/trader/ads'; // + /{id}/renew
  static String getFeaturedAds = '$baseAPI/ads/featured';

  ///// store hours
  static String getStoreHours = '$baseAPI/trader/store/hours';
  static String updateStoreHours = '$baseAPI/trader/store/hours';

  ///// analytics
  static String getAnalyticsOverview = '$baseAPI/trader/analytics/overview';
  static String getAdsAnalytics = '$baseAPI/trader/analytics/ads';
  static String getChartData = '$baseAPI/trader/analytics/chart'; // ?period=week/month/year

  ///// promotion
  static String getPromotionPackages = '$baseAPI/promotion-packages'; // GET - no auth
  static String promoteAd = '$baseAPI/trader/ads'; // + /{ad_id}/promote - POST
}

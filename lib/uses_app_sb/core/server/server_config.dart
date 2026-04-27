class ServerConstApis {
  // Base URL الجديد للـ Backend
  // static String baseAPI = 'http://localhost:8000/api';

  // للاستخدام على الأجهزة الحقيقية أو الإنتاج، قم بتغيير الـ URL
  // static String baseAPI = 'https://myadvertisement.shop/api';
  static String baseAPI = 'http://10.0.2.2:8000/api'; // للمحاكي Android

  static String version = '$baseAPI/version';
  static String register = '$baseAPI/user/register';
  static String login = '$baseAPI/user/login';
  static String logout = '$baseAPI/user/logout';
  static String deleteAccount = '$baseAPI/user/delete';
  static String getProfile = '$baseAPI/user/get/profile';
  static String updateProfile = '$baseAPI/user/update/profile';

  ///// category
  static String getStoresCategories = '$baseAPI/categories';

  ///// cities
  static String getCities = '$baseAPI/cities';

  ///// posts
  static String getAllPosts = '$baseAPI/user/get_posts'; // GET - with pagination
  static String createPost = '$baseAPI/posts/create'; // POST - trader only
  static String getMyPosts = '$baseAPI/posts/mine'; // GET - trader only
  static String deletePost = '$baseAPI/posts/delete'; // + /{post_id} - POST
  static String likePost = '$baseAPI/post/like'; // + /{post_id} - POST
  static String dislikePost = '$baseAPI/post/dislike'; // + /{post_id} - POST

  ///// ad
  static String getAdvertize = '$baseAPI/user/get_ads';
  static String getAdvertizeGuest = '$baseAPI/user/guest/get_ads';
  static String getStoreAdvertize = '$baseAPI/user/getStore_Ads';
  static String getFeaturedAds = '$baseAPI/ads/featured';

  ///// favorite
  static String toggleAdFavorite = '$baseAPI/user/add_to_favorite'; // + /{advertisement_id}
  static String toggleStoreFavorite = '$baseAPI/user/add_store_to_favorite'; // + /{store_id}
  static String getFavoriteAds = '$baseAPI/user/favoriteAdv';
  static String getFavoriteStores = '$baseAPI/user/favoriteStores';

  ///// search
  static String simpleSearch = '$baseAPI/user/search'; // GET - ?q={query}
  static String simpleSearchGuest = '$baseAPI/user/guest/search'; // GET - ?q={query}
  static String advancedSearch = '$baseAPI/search/advanced'; // POST - with filters
  static String searchStore = '$baseAPI/user/search/store';
  static String searchStoreGuest = '$baseAPI/user/guest/search/store';

  ///// stores
  static String getStoresByCategory = '$baseAPI/user/getStore_byCat'; // + /{category_id}
  static String getStoresByCategoryGuest = '$baseAPI/user/guest/getStore_byCat'; // + /{category_id}
  static String showStore = '$baseAPI/user/show_store'; // + /{store_id}
  static String showStoreGuest = '$baseAPI/user/guest/show_store'; // + /{store_id}
  static String getStorePosts = '$baseAPI/user/getStore_Post'; // + /{store_id}
  static String getStoreAdvertises = '$baseAPI/user/getStore_Ads'; // + /{store_id}
  static String getStoreAdvertisesGuest = '$baseAPI/user/guest/getStore_Ads'; // + /{store_id}
  static String getStoreByAdvertisement = '$baseAPI/user/getStore_pyAdv'; // + /{advertisement_id}
  static String blockStore = '$baseAPI/user/block/store';
  static String getBlockedStores = '$baseAPI/user/blocked/stores';

  ///// rating
  static String submitRating = '$baseAPI/user/rate'; // POST - submit rating
  static String getStoreRatings = '$baseAPI/user/rate'; // + /{store_id} - GET ratings

  ///// reports
  static String getReportReasons = '$baseAPI/reports/reasons'; // GET - no auth
  static String submitReport = '$baseAPI/reports'; // POST - submit report
  static String getMyReports = '$baseAPI/user/reports'; // GET - my reports

  ///// support
  static String getSupportInfo = '$baseAPI/support'; // GET - no auth
}

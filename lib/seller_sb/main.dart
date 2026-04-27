// import 'package:advertising_user/seller_sb/core/navigation/routes.dart';
// import 'package:advertising_user/seller_sb/core/services/connectivity_service.dart';
// import 'package:advertising_user/seller_sb/core/services/responsive.dart';
// import 'package:advertising_user/seller_sb/core/services/store_service.dart';
// import 'package:advertising_user/seller_sb/core/shared/models/user.dart';
  // import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// StoreService storeService = StoreService();
// String? targetRout = '/';
// late AppTheme appTheme;
// late Locale locale;
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await _loadLanguage();
//   await AppTheme.initialize();
//   Get.put(ConnectivityService());
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
//
//   // ignore: library_private_types_in_public_api
//   static _MyAppState of(BuildContext context) =>
//       context.findAncestorStateOfType<_MyAppState>()!;
// }
//
// class _MyAppState extends State<MyApp> {
//   ThemeMode _themeMode = AppTheme.themeMode;
//
//   @override
//   void initState() {
//     super.initState();
//     // Load the current theme mode when the app starts
//     _themeMode = AppTheme.themeMode;
//   }
//
//   void updateThemeMode() {
//     setState(() {
//       // Update the theme mode when it's toggled
//       _themeMode = AppTheme.themeMode;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     initSizes(context);
//
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (ctx, j) => GetMaterialApp(
//         translations: AppTranslations(),
//         locale: locale,
//         fallbackLocale: const Locale('en', 'US'),
//         theme: ThemeData(
//           brightness: Brightness.light,
//           splashColor: Colors.transparent, // Disable splash color globally
//           highlightColor:
//               Colors.transparent, // Disable highlight color globally
//           scrollbarTheme: const ScrollbarThemeData(),
//         ),
//         darkTheme: ThemeData(
//           brightness: Brightness.dark,
//           splashColor: Colors.transparent, // Disable splash color globally
//           highlightColor:
//               Colors.transparent, // Disable highlight color globally
//           scrollbarTheme: const ScrollbarThemeData(),
//         ),
//         themeMode: _themeMode,
//         debugShowCheckedModeBanner: false,
//         getPages: appRoutes(),
//         initialRoute: targetRout,
//         // initialRoute: '/SignInScreen',
//       ),
//     );
//   }
// }
//
// Future<void> _loadLanguage() async {
//   String language = await storeService.readString('language') ?? 'en';
//   if (await storeService.isContainKey('token')) {
//     print("contain token");
//     targetRout = '/MainBottomNavigationBarWidget';
//     token = await storeService.readString('token') ?? '';
//   } else {
//     targetRout = '/';
//   }
//   locale = Locale(language);
// }

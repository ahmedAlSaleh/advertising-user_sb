import 'package:advertising_user/AccountService.dart';
import 'package:advertising_user/uses_app_sb/core/navigation/routes.dart';
import 'package:advertising_user/uses_app_sb/core/services/connectivity_service.dart';
import 'package:advertising_user/uses_app_sb/core/services/responsive.dart';
import 'package:advertising_user/uses_app_sb/core/services/version_check_service.dart';
import 'package:advertising_user/uses_app_sb/core/shared/models/user.dart';
import 'package:advertising_user/uses_app_sb/core/translations/app_translations.dart';
import 'package:advertising_user/uses_app_sb/core/services/store_service.dart';
import 'package:advertising_user/uses_app_sb/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
StoreService storeService = StoreService();
String? targetRout = '/';
// Initialize with LightModeTheme, will be updated based on actual theme in didChangeDependencies
AppTheme appTheme = LightModeTheme();
late Locale locale;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadLanguage();
  await AppTheme.initialize();
  Get.put(ConnectivityService());
  Get.put(AccountService());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _themeMode = AppTheme.themeMode;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update global appTheme based on current brightness
    _updateGlobalTheme();
  }

  void _updateGlobalTheme() {
    // Determine current brightness based on theme mode
    final brightness = _getCurrentBrightness();
    appTheme = brightness == Brightness.dark ? DarkModeTheme() : LightModeTheme();
  }

  Brightness _getCurrentBrightness() {
    if (_themeMode == ThemeMode.dark) {
      return Brightness.dark;
    } else if (_themeMode == ThemeMode.light) {
      return Brightness.light;
    } else {
      // ThemeMode.system - use device brightness
      return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
  }

  void updateThemeMode() {
    setState(() {
      _themeMode = AppTheme.themeMode;
      _updateGlobalTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    initSizes(context);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (ctx, j) => GetMaterialApp(
        translations: AppTranslations(),
        locale: locale,
        fallbackLocale: const Locale('en', 'US'),
        theme: ThemeData(
          brightness: Brightness.light,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          scrollbarTheme: const ScrollbarThemeData(),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          scrollbarTheme: const ScrollbarThemeData(),
        ),
        themeMode: _themeMode,
        debugShowCheckedModeBanner: false,
        getPages: appRoutes(),

        initialRoute: targetRout,
      ),
    );
  }
}

Future<void> _loadLanguage() async {


  String language = await storeService.readString('language') ?? 'ar';
  locale = Locale(language);
  bool isUpToDate = await VersionCheckService.checkVersion();
  if (!isUpToDate) {
    targetRout = '/ForceUpdateScreen';
    return;
  }

  bool hasToken = await storeService.isContainKey('token');
  String? accountType = await storeService.readString('account_type');
  String? guestMode = await storeService.readString('guest_mode');

  if (hasToken && accountType != null) {
    String? savedToken = await storeService.readString('token');
    print("savedTokensavedTokensavedTokensavedToken");
    print(savedToken);

    if (savedToken != null && savedToken.isNotEmpty) {
      token = savedToken;

      if (accountType == 'user') {
        targetRout = '/UserMainBottomNavigationBarWidget';
      } else if (accountType == 'seller') {
        targetRout = '/SellerMainBottomNavigationBarWidget';
      } else {
        targetRout = '/AccountTypeSelection';
      }
    } else {
      await _clearData();
      targetRout = '/';
    }
  } else if (guestMode == 'true' && accountType == 'user') {
    targetRout = '/UserMainBottomNavigationBarWidget';
  } else {
    targetRout = '/';
  }
}

Future<void> _clearData() async {
  try {
    String language = await storeService.readString('language') ?? 'ar';
    await storeService.clearStorage();
    await storeService.createString('language', language);
  } catch (e) {
    print('Error clearing data: $e');
  }
}
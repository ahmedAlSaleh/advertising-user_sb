
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';
SharedPreferences? _prefs;

enum DeviceSize {
  mobile,
  tablet,
  desktop,
}

const String primaryFontFamily = 'NotoNaskhArabic';
const String secondaryFontFamily = 'NotoNaskhArabic';

abstract class AppTheme {
  static DeviceSize deviceSize = DeviceSize.mobile;

  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();

  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    // If no preference saved, use system theme (device theme)
    return darkMode == null
        ? ThemeMode.system
        : darkMode
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static ThemeMode toggleThemeMode() {
    final isDarkMode = _prefs?.getBool(kThemeModeKey) ?? false;
    final newThemeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    saveThemeMode(newThemeMode);
    return newThemeMode;
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? _prefs?.remove(kThemeModeKey)
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static AppTheme of(BuildContext context) {
    deviceSize = getDeviceSize(context);
    return Theme.of(context).brightness == Brightness.dark
        ? DarkModeTheme()
        : LightModeTheme();
  }

  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color accent1;
  late Color accent2;
  late Color accent3;
  late Color accent4;
  late Color success;
  late Color warning;
  late Color error;
  late Color info;
  late Color primaryBtnText;
  late Color lineColor;
  late Color white70;

  TextStyle get text10 => typography.text10;
  TextStyle get text12 => typography.text12;
  TextStyle get text14 => typography.text14;
  TextStyle get text16 => typography.text16;
  TextStyle get text18 => typography.text18;
  TextStyle get text24 => typography.text24;
  TextStyle get text26 => typography.text26;

  Typography get typography => {
    DeviceSize.mobile: MobileTypography(this),
    DeviceSize.tablet: TabletTypography(this),
    DeviceSize.desktop: DesktopTypography(this),
  }[deviceSize]!;
}

DeviceSize getDeviceSize(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 479) {
    return DeviceSize.mobile;
  } else if (width < 991) {
    return DeviceSize.tablet;
  } else {
    return DeviceSize.desktop;
  }
}

class LightModeTheme extends AppTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF9C7FE8); // Soft lavender purple
  late Color secondary = const Color(0xFFB399F5); // Light purple
  late Color tertiary = const Color(0xFF7C5FD3); // Deeper purple
  late Color alternate = const Color(0xFFE8DEFF); // Very light purple tint
  late Color primaryBackground = const Color(0xFFF5F3FF); // Light purple background
  late Color primaryText = const Color(0xFF1A1A2E); // Dark purple-tinted text
  late Color secondaryText = const Color(0xFF6B6B7E); // Medium gray-purple text
  late Color secondaryBackground = const Color(0xFFFFFFFF); // White cards/components
  late Color accent1 = const Color(0xFF8A8D91); // Medium gray
  late Color accent2 = const Color(0xFFC4B5FD); // Light purple accent
  late Color accent3 = const Color(0xFFE8DEFF); // Very light purple for borders
  late Color accent4 = const Color(0xFFF5F3FF); // Background purple tint
  late Color success = const Color(0xFFA78BFA); // Purple success
  late Color warning = const Color(0xFFFBBF24); // Warm yellow
  late Color error = const Color(0xFFEC4899); // Pink error for contrast
  late Color info = const Color(0xFF9C7FE8); // Soft lavender purple
  late Color primaryBtnText = const Color(0xFFFFFFFF);
  late Color lineColor = const Color(0xFFE0D4FF); // Light purple border
  late Color white70 = const Color(0xB3FFFFFF);
}

class DarkModeTheme extends AppTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFFA78BFA); // Bright purple for dark mode
  late Color secondary = const Color(0xFFA78BFA); // Bright purple
  late Color tertiary = const Color(0xFF9C7FE8); // Soft purple
  late Color alternate = const Color(0xFFA78BFA); // Bright purple accent
  late Color primaryText = const Color(0xFFE4E6EB); // Light gray text (like before)
  late Color secondaryText = const Color(0xFFB0B3B8); // Medium gray text (like before)
  late Color primaryBackground = const Color(0xFF000000); // Pure black background
  late Color secondaryBackground = const Color(0xFF18191A); // Very dark gray for cards
  late Color accent1 = const Color(0xFFE4E6EB); // Light text
  late Color accent2 = const Color(0xFFB0B3B8); // Medium gray text
  late Color accent3 = const Color(0xFF3A3B3C); // Dark border/separator
  late Color accent4 = const Color(0xFF18191A); // Card background
  late Color success = const Color(0xFFA78BFA); // Purple success
  late Color warning = const Color(0xFFFCDC0C); // Yellow warning
  late Color error = const Color(0xFFE21C3D); // Red error
  late Color info = const Color(0xFFA78BFA); // Purple info
  late Color primaryBtnText = const Color(0xFFFFFFFF);
  late Color lineColor = const Color(0xFF3A3B3C); // Dark border
  late Color white70 = const Color(0xB3FFFFFF);
}

abstract class Typography {
  TextStyle get text10;
  TextStyle get text12;
  TextStyle get text14;
  TextStyle get text16;
  TextStyle get text18;
  TextStyle get text24;
  TextStyle get text26;
}

class MobileTypography extends Typography {
  MobileTypography(this.theme);
  final AppTheme theme;

  TextStyle get text10 => TextStyle(

    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 10.0.sp,
  );
  TextStyle get text12 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 12.0.sp,
  );
  TextStyle get text14 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 14.0.sp,
  );
  TextStyle get text16 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 16.0.sp,
  );
  TextStyle get text18 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 18.0.sp,
  );
  TextStyle get text24 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 24.0.sp,
  );
  TextStyle get text26 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w500,
    fontSize: 26.0.sp,
  );
}

class TabletTypography extends Typography {
  TabletTypography(this.theme);
  final AppTheme theme;

  TextStyle get text10 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 10.0,
  );
  TextStyle get text12 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
  );
  TextStyle get text14 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 14.0,
  );
  TextStyle get text16 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
  );
  TextStyle get text18 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 18.0,
  );
  TextStyle get text24 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 24.0,
  );
  TextStyle get text26 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w500,
    fontSize: 26.0,
  );
}

class DesktopTypography extends Typography {
  DesktopTypography(this.theme);
  final AppTheme theme;

  TextStyle get text10 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 10.0,
  );
  TextStyle get text12 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
  );
  TextStyle get text14 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 14.0,
  );
  TextStyle get text16 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
  );
  TextStyle get text18 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 18.0,
  );
  TextStyle get text24 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 24.0,
  );
  TextStyle get text26 => TextStyle(
    fontFamily: primaryFontFamily,
    color: theme.primaryText,
    fontWeight: FontWeight.w500,
    fontSize: 26.0,
  );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      copyWith(
        fontFamily: fontFamily,
        color: color,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: decoration,
        height: lineHeight,
      );
}
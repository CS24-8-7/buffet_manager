import 'package:flutter/material.dart';

/// 🎨 الألوان
class AppColors {
  static const Color primary = Color(0xFFFF5252);
  static const Color secondary = Color(0xFF000505);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFF5F5F5);

  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE81515);
  static const Color warning = Color(0xFFFFC107);

  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);
}

/// 📏 الثوابت
class AppConstants {
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;
  static const double largeDesktopBreakpoint = 1200;

  // Padding
  static const double paddingXS = 4;
  static const double paddingS = 8;
  static const double paddingM = 16;
  static const double paddingL = 24;
  static const double paddingXL = 32;

  // Radius
  static const double radiusS = 4;
  static const double radiusM = 8;
  static const double radiusL = 12;
  static const double radiusXL = 16;

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}

/// 🖌️ الثيم
class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.backgroundLight,
      surface: AppColors.surfaceLight,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
    ),
    textTheme: _textTheme(AppColors.textPrimary, AppColors.textSecondary),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.secondary),
      titleTextStyle: TextStyle(
        fontFamily: "Roboto",
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.surfaceLight,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      titleTextStyle: const TextStyle(
        fontFamily: "Roboto",
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: "Roboto",
        fontSize: 16,
        color: AppColors.textSecondary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.backgroundDark,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: AppColors.textLight,
      onSurface: AppColors.textLight,
      onError: Colors.white,
    ),
    textTheme: _textTheme(AppColors.textLight, AppColors.textSecondary),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.textLight),
      titleTextStyle: TextStyle(
        fontFamily: "Roboto",
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.surfaceDark,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      titleTextStyle: const TextStyle(
        fontFamily: "Roboto",
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: "Roboto",
        fontSize: 16,
        color: AppColors.textLight,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textLight,
      type: BottomNavigationBarType.fixed,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
  );

  /// نصوص موحدة
  static TextTheme _textTheme(Color primary, Color secondary) {
    const fontFamily = "Roboto";

    return TextTheme(
      displayLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primary),
      displayMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primary),
      displaySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primary),
      bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: primary),
      bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: secondary),
      bodySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: secondary),
      labelLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: primary),
    );
  }
}

/// ✍️ النصوص المخصصة
class StylesApp {
  static const TextStyle titleStyle =
      TextStyle(fontSize: 40, fontWeight: FontWeight.w500);
  static const TextStyle titleDescStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

  static TextStyle itemNameStyle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary);
  static const TextStyle normalStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static TextStyle priceNormalStyle = TextStyle(
      fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.secondary);

  static TextStyle categoryNormalStyle = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.secondary);
  static TextStyle categoryNormalStyleSelect = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.backgroundLight);

  static TextStyle minusStyleSelect = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.backgroundLight);
  static TextStyle calcStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary);
  static TextStyle totalStyle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.secondary);
}

/// 📦 المسافات (SizedBox جاهزة)
class SpacesApp {
  static Widget h10 = const SizedBox(height: 10);
  static Widget h20 = const SizedBox(height: 20);
  static Widget h30 = const SizedBox(height: 30);
  static Widget h40 = const SizedBox(height: 40);
  static Widget h50 = const SizedBox(height: 50);

  static Widget w10 = const SizedBox(width: 10);
  static Widget w20 = const SizedBox(width: 20);
}

class ResponsiveHelper {
  // نقاط الكسر للشاشات
  static const double mobileBreakpoint = 480;
  static const double largePhoneBreakpoint = 600;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;
  static const double largeDesktopBreakpoint = 1200;
  static const double extraLargeDesktopBreakpoint = 1440;

  // تحديد أنواع الأجهزة
  static bool isSmallMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < largePhoneBreakpoint;
  }

  static bool isLargePhone(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeDesktopBreakpoint;
  }

  static bool isExtraLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= extraLargeDesktopBreakpoint;
  }

  // معلومات الشاشة
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  static Orientation getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  static bool isLandscape(BuildContext context) {
    return getOrientation(context) == Orientation.landscape;
  }

  static bool isPortrait(BuildContext context) {
    return getOrientation(context) == Orientation.portrait;
  }

  // عدد الأعمدة للشبكة حسب حجم الشاشة
  static int getGridColumns(BuildContext context) {
    if (isExtraLargeDesktop(context)) {
      return 6;
    } else if (isLargeDesktop(context)) {
      return 5;
    } else if (isDesktop(context)) {
      return 4;
    } else if (isTablet(context)) {
      return isLandscape(context) ? 4 : 3;
    } else if (isLargePhone(context)) {
      return isLandscape(context) ? 3 : 2;
    } else {
      return isLandscape(context) ? 2 : 1;
    }
  }

  // نسبة العرض إلى الارتفاع للبطاقات
  static double getCardAspectRatio(BuildContext context) {
    if (isDesktop(context)) {
      return 1.2;
    } else if (isTablet(context)) {
      return 1.1;
    } else {
      return 1.0;
    }
  }

  // المسافة بين العناصر
  static double getSpacing(BuildContext context) {
    if (isExtraLargeDesktop(context)) {
      return 32.0;
    } else if (isLargeDesktop(context)) {
      return 28.0;
    } else if (isDesktop(context)) {
      return 24.0;
    } else if (isTablet(context)) {
      return 16.0;
    } else if (isLargePhone(context)) {
      return 14.0;
    } else {
      return 12.0;
    }
  }

  // مسافة إضافية في الأسفل
  static double getBottomSpacing(BuildContext context) {
    if (isMobile(context)) {
      return 20.0;
    } else {
      return 0.0;
    }
  }

  // حجم الخط المتجاوب
  static double getResponsiveFontSize(
      BuildContext context, double baseFontSize) {
    final textScale = getTextScaleFactor(context);
    double scaleFactor = 1.0;

    if (isExtraLargeDesktop(context)) {
      scaleFactor = 1.15;
    } else if (isLargeDesktop(context)) {
      scaleFactor = 1.1;
    } else if (isDesktop(context)) {
      scaleFactor = 1.05;
    } else if (isTablet(context)) {
      scaleFactor = 1.02;
    } else if (isSmallMobile(context)) {
      scaleFactor = 0.95;
    }

    return baseFontSize * scaleFactor * textScale;
  }

  // الحشو المتجاوب
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isExtraLargeDesktop(context)) {
      return const EdgeInsets.all(40.0);
    } else if (isLargeDesktop(context)) {
      return const EdgeInsets.all(36.0);
    } else if (isDesktop(context)) {
      return const EdgeInsets.all(32.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else if (isLargePhone(context)) {
      return const EdgeInsets.all(18.0);
    } else {
      return const EdgeInsets.all(12.0);
    }
  }

  // عرض الشريط الجانبي
  static double getSidebarWidth(BuildContext context) {
    if (isExtraLargeDesktop(context)) {
      return 320.0;
    } else if (isLargeDesktop(context)) {
      return 300.0;
    } else if (isDesktop(context)) {
      return 280.0;
    } else if (isTablet(context)) {
      return 260.0;
    } else {
      return 240.0;
    }
  }

  // ارتفاع شريط التطبيق
  static double getAppBarHeight(BuildContext context) {
    if (isDesktop(context)) {
      return 72.0;
    } else if (isTablet(context)) {
      return 64.0;
    } else {
      return 56.0;
    }
  }

  // حجم الأيقونات
  static double getIconSize(BuildContext context) {
    if (isExtraLargeDesktop(context)) {
      return 32.0;
    } else if (isLargeDesktop(context)) {
      return 30.0;
    } else if (isDesktop(context)) {
      return 28.0;
    } else if (isTablet(context)) {
      return 26.0;
    } else if (isLargePhone(context)) {
      return 25.0;
    } else {
      return 24.0;
    }
  }

  // ارتفاع الأزرار
  static double getButtonHeight(BuildContext context) {
    final textScale = getTextScaleFactor(context);
    double baseHeight;

    if (isDesktop(context)) {
      baseHeight = 48.0;
    } else if (isTablet(context)) {
      baseHeight = 46.0;
    } else if (isLargePhone(context)) {
      baseHeight = 52.0;
    } else {
      baseHeight = 50.0;
    }

    return baseHeight * textScale;
  }

  // عرض البطاقة القصوى
  static double getMaxCardWidth(BuildContext context) {
    if (isExtraLargeDesktop(context)) {
      return 350.0;
    } else if (isLargeDesktop(context)) {
      return 320.0;
    } else if (isDesktop(context)) {
      return 300.0;
    } else if (isTablet(context)) {
      return 280.0;
    } else {
      return double.infinity;
    }
  }

  // تحديد ما إذا كان يجب إظهار الشريط الجانبي
  static bool shouldShowSidebar(BuildContext context) {
    return isTablet(context) || isDesktop(context);
  }

  // تحديد ما إذا كان يجب إظهار لوحة التحكم
  static bool shouldShowDashboard(BuildContext context) {
    return isDesktop(context);
  }

  // عدد العناصر في الصف للقوائم
  static int getListItemsPerRow(BuildContext context) {
    if (isExtraLargeDesktop(context)) {
      return 4;
    } else if (isLargeDesktop(context)) {
      return 3;
    } else if (isDesktop(context)) {
      return 3;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 1;
    }
  }

  // حجم الصورة في البطاقة
  static double getCardImageSize(BuildContext context) {
    if (isExtraLargeDesktop(context)) {
      return 140.0;
    } else if (isLargeDesktop(context)) {
      return 130.0;
    } else if (isDesktop(context)) {
      return 120.0;
    } else if (isTablet(context)) {
      return 100.0;
    } else if (isLargePhone(context)) {
      return 90.0;
    } else {
      return 80.0;
    }
  }

  // === دوال جديدة للتحسينات ===

  // ارتفاع الهيدر
  static double getHeaderHeight(BuildContext context, bool isDesktop) {
    if (isDesktop) {
      if (isExtraLargeDesktop(context)) {
        return 140.0;
      } else if (isLargeDesktop(context)) {
        return 130.0;
      } else {
        return 120.0;
      }
    } else {
      if (isTablet(context)) {
        return 160.0;
      } else if (isLargePhone(context)) {
        return 170.0;
      } else {
        return 180.0;
      }
    }
  }

  // نصف قطر الأفاتار
  static double getAvatarRadius(BuildContext context, bool isDesktop) {
    if (isDesktop) {
      if (isExtraLargeDesktop(context)) {
        return 28.0;
      } else if (isLargeDesktop(context)) {
        return 26.0;
      } else {
        return 24.0;
      }
    } else {
      if (isTablet(context)) {
        return 32.0;
      } else if (isLargePhone(context)) {
        return 30.0;
      } else {
        return 28.0;
      }
    }
  }

  // حجم أيقونة الهيدر
  static double getHeaderIconSize(BuildContext context, bool isDesktop) {
    if (isDesktop) {
      if (isExtraLargeDesktop(context)) {
        return 32.0;
      } else if (isLargeDesktop(context)) {
        return 30.0;
      } else {
        return 28.0;
      }
    } else {
      if (isTablet(context)) {
        return 36.0;
      } else if (isLargePhone(context)) {
        return 34.0;
      } else {
        return 32.0;
      }
    }
  }

  // حشو الهيدر
  static EdgeInsets getHeaderPadding(BuildContext context, bool isDesktop) {
    final spacing = getSpacing(context);
    if (isDesktop) {
      return EdgeInsets.all(spacing * 0.75);
    } else {
      return EdgeInsets.fromLTRB(spacing, spacing * 1.25, spacing, spacing);
    }
  }

  // مسافة الهيدر
  static double getHeaderSpacing(BuildContext context) {
    if (isExtraLargeDesktop(context)) {
      return 12.0;
    } else if (isLargeDesktop(context)) {
      return 10.0;
    } else if (isDesktop(context)) {
      return 8.0;
    } else if (isTablet(context)) {
      return 10.0;
    } else {
      return 16.0;
    }
  }

  // حجم خط عنوان الهيدر
  static double getHeaderTitleFontSize(BuildContext context) {
    return getResponsiveFontSize(context, isDesktop(context) ? 16.0 : 20.0);
  }

  // حجم خط الدور
  static double getRoleFontSize(BuildContext context) {
    return getResponsiveFontSize(context, isDesktop(context) ? 12.0 : 14.0);
  }

  // حشو شارة الدور
  static EdgeInsets getRoleBadgePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 8, vertical: 3);
    } else {
      return const EdgeInsets.symmetric(horizontal: 10, vertical: 4);
    }
  }

  // نصف قطر شارة الدور
  static double getRoleBadgeRadius(BuildContext context) {
    return isDesktop(context) ? 10.0 : 12.0;
  }

  // سماكة الفاصل
  static double getDividerThickness(BuildContext context) {
    return isDesktop(context) ? 0.8 : 1.0;
  }

  // حجم خط عنوان القسم
  static double getSectionTitleFontSize(BuildContext context) {
    return getResponsiveFontSize(context, 13.0);
  }

  // مسافة أسفل عنوان القسم
  static double getSectionTitleBottomSpacing(BuildContext context) {
    return isDesktop(context) ? 6.0 : 8.0;
  }

  // تباعد الأحرف
  static double getLetterSpacing(BuildContext context) {
    return isDesktop(context) ? 0.3 : 0.5;
  }

  // هامش عنصر الدرج
  static EdgeInsets getDrawerItemMargin(BuildContext context) {
    final spacing = getSpacing(context);
    return EdgeInsets.symmetric(
      horizontal: spacing / 2,
      vertical: isDesktop(context) ? 1.0 : 2.0,
    );
  }

  // حشو عنصر الدرج
  static EdgeInsets getDrawerItemPadding(BuildContext context, bool isDesktop) {
    final spacing = getSpacing(context);
    return EdgeInsets.symmetric(
      horizontal: spacing,
      vertical: isDesktop ? 6.0 : 8.0,
    );
  }

  // حجم خط عنصر الدرج
  static double getDrawerItemFontSize(BuildContext context) {
    return getResponsiveFontSize(context, 15.0);
  }

  // نصف قطر حدود عنصر الدرج
  static double getDrawerItemBorderRadius(BuildContext context) {
    return isDesktop(context) ? 10.0 : 12.0;
  }

  // حشو زر تسجيل الخروج
  static EdgeInsets getLogoutButtonPadding(BuildContext context) {
    final spacing = getSpacing(context);
    return EdgeInsets.fromLTRB(spacing, spacing / 2, spacing, spacing);
  }

  // حجم خط الزر
  static double getButtonFontSize(BuildContext context) {
    return getResponsiveFontSize(context, 15.0);
  }

  // نصف قطر حدود الزر
  static double getButtonBorderRadius(BuildContext context) {
    return isDesktop(context) ? 10.0 : 12.0;
  }

  // ارتفاع الزر
  static double getButtonElevation(BuildContext context) {
    return isDesktop(context) ? 2.0 : 3.0;
  }

  // عرض الحدود
  static double getBorderWidth(BuildContext context) {
    return isDesktop(context) ? 0.8 : 1.0;
  }

  // شفافية الظل
  static double getShadowOpacity(BuildContext context) {
    return isDesktop(context) ? 0.03 : 0.05;
  }

  // نصف قطر ضبابية الظل
  static double getShadowBlurRadius(BuildContext context) {
    return isDesktop(context) ? 8.0 : 10.0;
  }

  // إزاحة الظل
  static double getShadowOffset(BuildContext context) {
    return isDesktop(context) ? 1.0 : 2.0;
  }

  // === دوال الحوارات ===

  // نصف قطر حدود الحوار
  static double getDialogBorderRadius(BuildContext context) {
    return isDesktop(context) ? 12.0 : 16.0;
  }

  // عرض الحوار
  static double getDialogWidth(BuildContext context) {
    if (isExtraLargeDesktop(context)) {
      return 450.0;
    } else if (isLargeDesktop(context)) {
      return 420.0;
    } else if (isDesktop(context)) {
      return 400.0;
    } else if (isTablet(context)) {
      return 350.0;
    } else {
      return getScreenWidth(context) * 0.9;
    }
  }

  // حجم خط عنوان الحوار
  static double getDialogTitleFontSize(BuildContext context) {
    return getResponsiveFontSize(context, 18.0);
  }

  // حجم خط محتوى الحوار
  static double getDialogContentFontSize(BuildContext context) {
    return getResponsiveFontSize(context, 16.0);
  }

  // حجم خط زر الحوار
  static double getDialogButtonFontSize(BuildContext context) {
    return getResponsiveFontSize(context, 15.0);
  }

  // العرض الأدنى لزر الحوار
  static double getDialogButtonMinWidth(BuildContext context) {
    return isDesktop(context) ? 80.0 : 90.0;
  }

  // ارتفاع زر الحوار
  static double getDialogButtonHeight(BuildContext context) {
    return getButtonHeight(context) * 0.85;
  }

  // === دوال حقول النص ===

  // حجم خط حقل النص
  static double getTextFieldFontSize(BuildContext context) {
    return getResponsiveFontSize(context, 16.0);
  }

  // حجم خط تسمية حقل النص
  static double getTextFieldLabelFontSize(BuildContext context) {
    return getResponsiveFontSize(context, 14.0);
  }

  // حجم أيقونة حقل النص
  static double getTextFieldIconSize(BuildContext context) {
    return getIconSize(context) * 0.9;
  }

  // حشو حقل النص
  static EdgeInsets getTextFieldPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
    }
  }

  // مسافة بين حقول النموذج
  static double getFormFieldSpacing(BuildContext context) {
    return getSpacing(context) * 0.75;
  }
}

// ويدجت مساعد للتصميم المتجاوب
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
          BuildContext context, bool isMobile, bool isTablet, bool isDesktop)
      builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveHelper.isMobile(context);
        final isTablet = ResponsiveHelper.isTablet(context);
        final isDesktop = ResponsiveHelper.isDesktop(context);

        return builder(context, isMobile, isTablet, isDesktop);
      },
    );
  }
}

// ويدجت للتخطيط المتجاوب
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, isMobile, isTablet, isDesktop) {
        if (ResponsiveHelper.isLargeDesktop(context) && largeDesktop != null) {
          return largeDesktop!;
        } else if (isDesktop && desktop != null) {
          return desktop!;
        } else if (isTablet && tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}

// ويدجت للحاوية المتجاوبة
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? ResponsiveHelper.getMaxCardWidth(context),
      ),
      padding: padding ?? ResponsiveHelper.getResponsivePadding(context),
      margin: margin,
      child: child,
    );
  }
}

// ويدجت للشبكة المتجاوبة
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? spacing;
  final double? runSpacing;
  final int? crossAxisCount;

  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.spacing,
    this.runSpacing,
    this.crossAxisCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final columns = crossAxisCount ?? ResponsiveHelper.getGridColumns(context);
    final space = spacing ?? ResponsiveHelper.getSpacing(context);

    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: space,
      mainAxisSpacing: runSpacing ?? space,
      childAspectRatio: ResponsiveHelper.getCardAspectRatio(context),
      children: children,
    );
  }
}

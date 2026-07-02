import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
  ThemeMode.dark,
);

class AppTheme {
  AppTheme._();

  static TextTheme _txt(Color c) => GoogleFonts.plusJakartaSansTextTheme(
    TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: c,
        letterSpacing: -1.5,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: c,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: c,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: c,
      ),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: c),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: c,
      ),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: c),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: c,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: c,
      ),
    ),
  );

  static InputDecorationTheme _inp(Color fill, Color border) =>
      InputDecorationTheme(
        filled: true,
        fillColor: fill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      );

  static ElevatedButtonThemeData get _btn => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  static NavigationBarThemeData _nav(bool dark) => NavigationBarThemeData(
    backgroundColor: dark ? AppColors.darkCard : AppColors.lightCard,
    indicatorColor: AppColors.primary,
    labelTextStyle: WidgetStateProperty.resolveWith((s) {
      final a = s.contains(WidgetState.selected);
      return GoogleFonts.plusJakartaSans(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        color: a
            ? AppColors.primary
            : (dark ? AppColors.white35 : const Color(0xFF64748B)),
      );
    }),
    iconTheme: WidgetStateProperty.resolveWith((s) {
      final a = s.contains(WidgetState.selected);
      return IconThemeData(
        color: a
            ? Colors.white
            : (dark ? AppColors.white35 : const Color(0xFF64748B)),
        size: 20,
      );
    }),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.darkCard,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBg,
    cardColor: AppColors.darkCard,
    textTheme: _txt(Colors.white),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBg,
      foregroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    navigationBarTheme: _nav(true),
    elevatedButtonTheme: _btn,
    dividerColor: AppColors.darkBorder,
    inputDecorationTheme: _inp(AppColors.white10, AppColors.darkBorder),
  );

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.lightCard,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSurface: Color(0xFF0F172A),
    ),
    scaffoldBackgroundColor: AppColors.lightBg,
    cardColor: AppColors.lightCard,
    textTheme: _txt(const Color(0xFF0F172A)),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBg,
      foregroundColor: Color(0xFF0F172A),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    navigationBarTheme: _nav(false),
    elevatedButtonTheme: _btn,
    dividerColor: AppColors.lightBorder,
    inputDecorationTheme: _inp(const Color(0xFFF1F5F9), AppColors.lightBorder),
  );
}

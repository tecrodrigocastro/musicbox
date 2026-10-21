import 'package:flutter/material.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';

/// Tema escuro do app, derivado de `design/DESIGN.md`.
///
/// Sem sombras e sem gradientes: profundidade vem do degrau entre superfícies
/// e de bordas de 1px. Raios: botões e inputs 8, cards 12, pílulas 999.
class AppTheme {
  AppTheme._();

  static const double buttonRadius = 8;
  static const double cardRadius = 12;

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.violet600,
      onPrimary: AppColors.ice,
      secondary: AppColors.violet400,
      onSecondary: AppColors.canvas,
      error: AppColors.alertRose,
      onError: AppColors.canvas,
      surface: AppColors.graphite,
      onSurface: AppColors.ice,
      outline: AppColors.linen,
      outlineVariant: AppColors.iron,
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonRadius),
    );

    OutlineInputBorder inputBorder(Color color) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(buttonRadius),
        borderSide: BorderSide(color: color),
      );
    }

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.canvas,
      fontFamily: AppTextStyles.sans,
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.display,
        headlineMedium: AppTextStyles.heading,
        titleLarge: AppTextStyles.title,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.bodySmall,
        labelMedium: AppTextStyles.label,
        labelSmall: AppTextStyles.caption,
      ),
      dividerColor: AppColors.iron,
      dividerTheme: const DividerThemeData(color: AppColors.iron, thickness: 1, space: 1),
      iconTheme: const IconThemeData(color: AppColors.ice),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.ice,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.heading,
      ),
      // Ação primária: o único elemento preenchido de cada tela.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.violet600,
          foregroundColor: AppColors.ice,
          disabledBackgroundColor: AppColors.slate,
          disabledForegroundColor: AppColors.fog,
          minimumSize: const Size(0, 48),
          elevation: 0,
          shape: buttonShape,
          textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.violet600,
          foregroundColor: AppColors.ice,
          disabledBackgroundColor: AppColors.slate,
          disabledForegroundColor: AppColors.fog,
          minimumSize: const Size(0, 48),
          elevation: 0,
          shape: buttonShape,
          textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      // Ações secundárias: contorno em Linen, rótulo em Fog.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.fog,
          side: const BorderSide(color: AppColors.linen),
          minimumSize: const Size(0, 48),
          shape: buttonShape,
          textStyle: AppTextStyles.body,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.violet400,
          textStyle: AppTextStyles.body,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.carbon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.fog),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.alertRose),
        border: inputBorder(AppColors.linen),
        enabledBorder: inputBorder(AppColors.linen),
        focusedBorder: inputBorder(AppColors.violet400),
        errorBorder: inputBorder(AppColors.alertRose),
        focusedErrorBorder: inputBorder(AppColors.alertRose),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.slate,
        contentTextStyle: AppTextStyles.body,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          side: const BorderSide(color: AppColors.iron),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.slate,
        textStyle: AppTextStyles.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          side: const BorderSide(color: AppColors.iron),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.violet400),
    );
  }
}

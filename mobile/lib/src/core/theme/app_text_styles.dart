import 'package:flutter/material.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';

/// Escala tipográfica de `design/DESIGN.md`.
///
/// Instrument Sans em peso 400 para interface e títulos (o peso 600 existe só
/// para numerais de estatística); JetBrains Mono com tracking largo para
/// micro-rótulos, IDs, datas e valores de enum.
///
/// As famílias são referenciadas pelo nome. Enquanto os arquivos `.ttf` não
/// forem declarados no `pubspec.yaml`, o Flutter cai para a fonte do sistema
/// (e `monospace` no caso do mono), sem quebrar nada.
class AppTextStyles {
  AppTextStyles._();

  static const String sans = 'Instrument Sans';
  static const String mono = 'JetBrains Mono';
  static const List<String> _monoFallback = ['monospace'];

  /// 32px, títulos de página.
  static const TextStyle display = TextStyle(
    fontFamily: sans,
    fontSize: 32,
    height: 1.1,
    letterSpacing: -0.64,
    fontWeight: FontWeight.w400,
    color: AppColors.ice,
  );

  /// 24px, títulos de seção e de modal.
  static const TextStyle heading = TextStyle(
    fontFamily: sans,
    fontSize: 24,
    height: 1.2,
    letterSpacing: -0.24,
    fontWeight: FontWeight.w400,
    color: AppColors.ice,
  );

  /// 18px, nome da entidade em telas de detalhe.
  static const TextStyle title = TextStyle(
    fontFamily: sans,
    fontSize: 18,
    height: 1.3,
    letterSpacing: -0.18,
    fontWeight: FontWeight.w400,
    color: AppColors.ice,
  );

  /// 14px, células, descrições e botões.
  static const TextStyle body = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    height: 1.6,
    letterSpacing: 0.14,
    fontWeight: FontWeight.w400,
    color: AppColors.ice,
  );

  /// 13px, texto de apoio e mensagens de validação.
  static const TextStyle bodySmall = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    height: 1.45,
    letterSpacing: 0.13,
    fontWeight: FontWeight.w400,
    color: AppColors.fog,
  );

  /// 12px mono, valores como IDs e datas.
  static const TextStyle label = TextStyle(
    fontFamily: mono,
    fontFamilyFallback: _monoFallback,
    fontSize: 12,
    height: 1.2,
    letterSpacing: 0.96,
    fontWeight: FontWeight.w500,
    color: AppColors.fog,
  );

  /// 10px mono, rótulos em caixa alta e badges.
  static const TextStyle caption = TextStyle(
    fontFamily: mono,
    fontFamilyFallback: _monoFallback,
    fontSize: 10,
    height: 1,
    letterSpacing: 1.6,
    fontWeight: FontWeight.w500,
    color: AppColors.fog,
  );
}

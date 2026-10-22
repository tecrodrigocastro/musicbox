import 'package:flutter/material.dart';

/// Tokens de cor de `design/DESIGN.md`.
///
/// Superfícies empilham em charcoals com tom violeta (sem sombras); o violeta
/// 600 é a única cor de preenchimento do sistema. Âmbar e rosa são cores
/// semânticas de status e nunca decoração.
class AppColors {
  AppColors._();

  // Superfícies, da mais funda para a mais elevada.
  static const Color canvas = Color(0xFF08070C); // "Void": fundo da página
  static const Color carbon = Color(0xFF0E0D13); // shell, inputs, barra inferior
  static const Color graphite = Color(0xFF15141C); // cards e tabelas
  static const Color slate = Color(0xFF1C1A25); // menus, linhas em hover

  // Linhas.
  static const Color iron = Color(0xFF2A2835); // divisórias entre superfícies
  static const Color steel = Color(0xFF4A4759); // hairline decorativa
  static const Color linen = Color(0xFF6F6B80); // borda que carrega estado

  // Texto.
  static const Color fog = Color(0xFF8B8799); // texto secundário
  static const Color ice = Color(0xFFECE9F5); // texto primário

  // Acento.
  static const Color violet300 = Color(0xFFC4B5FD);
  static const Color violet400 = Color(0xFFA78BFA); // violeta como texto/link
  static const Color violet600 = Color(0xFF7C3AED); // fill da ação primária
  static const Color violet700 = Color(0xFF6D28D9); // estado pressionado

  // Status (semânticos).
  static const Color signalAmber = Color(0xFFFBBF24); // queued / stale
  static const Color alertRose = Color(0xFFFB7185); // failed / destrutivo

  /// Tons das capas placeholder, usados enquanto não há `thumbnail_url`.
  static const List<Color> coverTones = [
    Color(0xFF241F35),
    Color(0xFF1C1A25),
    Color(0xFF2A2240),
    Color(0xFF1F2230),
  ];
}

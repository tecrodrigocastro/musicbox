import 'package:flutter/material.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';

/// Micro-rótulo em JetBrains Mono, caixa alta e tracking largo.
///
/// É a assinatura "telemetria" do design: rótulos de campo, de seção, de
/// status e de tipo de release.
class MonoLabelWidget extends StatelessWidget {
  const MonoLabelWidget(
    this.text, {
    super.key,
    this.color = AppColors.fog,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.caption.copyWith(color: color),
    );
  }
}

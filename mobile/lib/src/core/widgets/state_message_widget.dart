import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';

/// Painel de contorno para estados vazio e de erro (Hairline Panel Frame).
///
/// Erros usam o contorno em Alert Rose, nunca preenchimento; o resto usa
/// Linen. A ação opcional é sempre um botão de contorno.
class StateMessageWidget extends StatelessWidget {
  const StateMessageWidget({
    super.key,
    required this.label,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.isError = false,
  });

  final String label;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final action = onAction;
    final actionText = actionLabel;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isError ? AppColors.alertRose : AppColors.linen),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MonoLabelWidget(label, color: isError ? AppColors.alertRose : AppColors.fog),
          const Gap(8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
          if (action != null && actionText != null) ...[
            const Gap(16),
            OutlinedButton(
              onPressed: action,
              child: Text(actionText),
            ),
          ],
        ],
      ),
    );
  }
}

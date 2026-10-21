import 'package:flutter/material.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';

/// Chip de filtro em pílula: contorno violeta quando selecionado, Iron quando
/// não. Sem preenchimento, como o resto do design.
class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: isSelected ? AppColors.violet400 : AppColors.iron),
          ),
          child: MonoLabelWidget(label, color: isSelected ? AppColors.violet400 : AppColors.fog),
        ),
      ),
    );
  }
}

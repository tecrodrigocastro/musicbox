import 'package:flutter/material.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';

/// Seletor de nota de 1 a [max], com alvos de toque de 44px.
///
/// Tocar na estrela que já é a nota atual limpa a nota (a nota é opcional).
class RatingPickerWidget extends StatelessWidget {
  const RatingPickerWidget({
    super.key,
    required this.rating,
    required this.onChanged,
    this.max = 5,
  });

  final int? rating;
  final ValueChanged<int?> onChanged;
  final int max;

  @override
  Widget build(BuildContext context) {
    final current = rating ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var value = 1; value <= max; value++)
          Semantics(
            button: true,
            label: 'Nota $value de $max',
            selected: value == current,
            child: InkResponse(
              onTap: () => onChanged(value == current ? null : value),
              radius: 24,
              child: SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  value <= current ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 32,
                  color: value <= current ? AppColors.violet400 : AppColors.steel,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

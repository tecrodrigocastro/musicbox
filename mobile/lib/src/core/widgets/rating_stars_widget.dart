import 'package:flutter/material.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';

/// Nota de 1 a [max] em estrelas, somente leitura.
///
/// Estrelas preenchidas em violet-400; as vazias em Steel. A nota é anunciada
/// uma única vez para leitores de tela, em vez de uma estrela por vez.
class RatingStarsWidget extends StatelessWidget {
  const RatingStarsWidget({
    super.key,
    required this.rating,
    this.size = 12,
    this.max = 5,
    this.spacing = 2,
  });

  final int rating;
  final double size;
  final int max;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Nota $rating de $max',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= max; i++)
              Padding(
                padding: EdgeInsets.only(left: i == 1 ? 0 : spacing),
                child: Icon(
                  i <= rating ? Icons.star : Icons.star_border,
                  size: size,
                  color: i <= rating ? AppColors.violet400 : AppColors.steel,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

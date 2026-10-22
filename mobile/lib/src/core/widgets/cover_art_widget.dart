import 'package:flutter/material.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';

/// Capa de release ou imagem de artista.
///
/// - Com [imageUrl]: a imagem do provedor, a 80% de opacidade para que uma
///   grade de capas leia como uma única superfície (regra do DESIGN.md).
/// - Sem imagem: quadrado tonal com um círculo (placeholder de protótipo). O
///   tom vem de [seed], então o mesmo item sempre tem a mesma cor.
/// - Com [showNoArt]: célula Graphite com o rótulo `NO_ART`, nunca um ícone
///   de imagem quebrada.
class CoverArtWidget extends StatelessWidget {
  const CoverArtWidget({
    super.key,
    required this.size,
    this.seed = '',
    this.radius = 6,
    this.imageUrl,
    this.showNoArt = false,
  });

  final double size;
  final String seed;
  final double radius;
  final String? imageUrl;
  final bool showNoArt;

  Color get _tone {
    final sum = seed.codeUnits.fold<int>(0, (total, unit) => total + unit);
    return AppColors.coverTones[sum % AppColors.coverTones.length];
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);

    if (showNoArt) {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.graphite,
          borderRadius: borderRadius,
          border: Border.all(color: AppColors.iron),
        ),
        child: Text(
          'NO_ART',
          style: AppTextStyles.caption.copyWith(letterSpacing: 0.8),
        ),
      );
    }

    final url = imageUrl;
    // Só URLs http(s) viram imagem de rede; qualquer outro valor (como o
    // `mock:` dos repositórios de mentira) desenha o placeholder tonal.
    if (url != null && url.startsWith('http')) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Opacity(
          opacity: 0.8,
          child: Image.network(
            url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _placeholder(borderRadius),
          ),
        ),
      );
    }

    return _placeholder(borderRadius);
  }

  Widget _placeholder(BorderRadius borderRadius) {
    return Opacity(
      opacity: 0.8,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: _tone, borderRadius: borderRadius),
        child: Container(
          width: size * 0.6,
          height: size * 0.6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.steel),
          ),
        ),
      ),
    );
  }
}

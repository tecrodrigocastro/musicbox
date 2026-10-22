import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_entity.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/widgets/cover_art_widget.dart';

/// Linha de artista nos resultados da busca: imagem, nome e seta.
///
/// Artista sem imagem mostra a célula `NO_ART`, nunca um ícone quebrado.
class ArtistTileWidget extends StatelessWidget {
  const ArtistTileWidget({super.key, required this.artist, required this.onTap});

  final ArtistEntity artist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CoverArtWidget(
              size: 48,
              radius: 999,
              seed: artist.id,
              imageUrl: artist.thumbnailUrl,
              showNoArt: artist.thumbnailUrl == null,
            ),
            const Gap(12),
            Expanded(
              child: Text(
                artist.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.linen, size: 20),
          ],
        ),
      ),
    );
  }
}

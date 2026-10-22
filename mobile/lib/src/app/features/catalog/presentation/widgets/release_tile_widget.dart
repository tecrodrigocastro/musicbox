import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/catalog/presentation/extensions/release_type_label_extension.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/widgets/cover_art_widget.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';

/// Linha de release: capa, título, "TIPO · ANO" e um [trailing] opcional
/// (ação ou estado do registro do usuário).
class ReleaseTileWidget extends StatelessWidget {
  const ReleaseTileWidget({
    super.key,
    required this.release,
    this.onTap,
    this.trailing,
    this.showArtist = false,
  });

  final ReleaseEntity release;
  final VoidCallback? onTap;
  final Widget? trailing;

  /// Mostra o nome do artista sob o título (listas que misturam artistas).
  final bool showArtist;

  @override
  Widget build(BuildContext context) {
    final year = release.releaseYear;
    final meta = [release.type.label, if (year != null) '$year'].join(' · ');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CoverArtWidget(size: 48, seed: release.id, imageUrl: release.thumbnailUrl),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    release.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title,
                  ),
                  if (showArtist && release.artists.isNotEmpty) ...[
                    const Gap(2),
                    Text(
                      release.artistNames,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                  const Gap(6),
                  MonoLabelWidget(meta, color: AppColors.fog),
                ],
              ),
            ),
            if (trailing != null) ...[const Gap(12), trailing!],
          ],
        ),
      ),
    );
  }
}

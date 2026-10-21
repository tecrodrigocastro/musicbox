import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/widgets/cover_art_widget.dart';

/// Item do carrossel "Novos no catálogo": capa quadrada, título e artista.
class NewReleaseCardWidget extends StatelessWidget {
  const NewReleaseCardWidget({super.key, required this.release, required this.onTap, this.size = 128});

  final ReleaseEntity release;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoverArtWidget(size: size, radius: 8, seed: release.id, imageUrl: release.thumbnailUrl),
            const Gap(8),
            Text(release.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.body),
            Text(release.artistNames, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

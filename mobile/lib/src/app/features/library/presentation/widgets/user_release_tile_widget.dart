import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/catalog/presentation/extensions/release_type_label_extension.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';
import 'package:musicbox/src/app/features/library/presentation/extensions/user_release_status_label_extension.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/utils/date_format.dart';
import 'package:musicbox/src/core/widgets/cover_art_widget.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';
import 'package:musicbox/src/core/widgets/rating_stars_widget.dart';

/// Linha da biblioteca: capa, título, artista e, à direita, nota e data
/// (status "Ouvi") ou apenas o status.
class UserReleaseTileWidget extends StatelessWidget {
  const UserReleaseTileWidget({super.key, required this.entry, required this.onTap});

  final UserReleaseEntity entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ReleaseEntity? release = entry.release;
    final rating = entry.rating;
    final listenedAt = entry.listenedAt;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CoverArtWidget(size: 48, seed: entry.releaseId, imageUrl: release?.thumbnailUrl),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    release?.title ?? 'Release',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title,
                  ),
                  const Gap(2),
                  Text(
                    release == null ? '' : '${release.artistNames} · ${release.type.label}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const Gap(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (entry.status == UserReleaseStatus.listened) ...[
                  if (rating != null) RatingStarsWidget(rating: rating),
                  if (listenedAt != null) ...[
                    const Gap(6),
                    MonoLabelWidget(formatIsoDate(listenedAt)),
                  ],
                ] else
                  MonoLabelWidget(
                    entry.status.label,
                    color: entry.status == UserReleaseStatus.listening ? AppColors.violet400 : AppColors.fog,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

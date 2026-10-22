import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:musicbox/src/app/features/artist/presentation/bloc/artist_bloc.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_catalog_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_type.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/sync_status.dart';
import 'package:musicbox/src/app/features/catalog/presentation/extensions/release_type_label_extension.dart';
import 'package:musicbox/src/app/features/catalog/presentation/widgets/release_tile_widget.dart';
import 'package:musicbox/src/app/features/catalog/presentation/widgets/sync_status_badge_widget.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';
import 'package:musicbox/src/app/features/library/presentation/extensions/user_release_status_label_extension.dart';
import 'package:musicbox/src/core/DI/dependency_injector.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/widgets/cover_art_widget.dart';
import 'package:musicbox/src/core/widgets/filter_chip_widget.dart';
import 'package:musicbox/src/core/widgets/hairline_card_widget.dart';
import 'package:musicbox/src/core/widgets/loading_indicator_widget.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';
import 'package:musicbox/src/core/widgets/rating_stars_widget.dart';
import 'package:musicbox/src/core/widgets/state_message_widget.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage({super.key, required this.artistId});

  final String artistId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<ArtistBloc>()..add(ArtistLoadRequested(artistId: artistId)),
      child: _ArtistView(artistId: artistId),
    );
  }
}

class _ArtistView extends StatelessWidget {
  const _ArtistView({required this.artistId});

  final String artistId;

  void _load(BuildContext context, ReleaseType? type) {
    context.read<ArtistBloc>().add(ArtistLoadRequested(artistId: artistId, type: type));
  }

  /// Abre o registro; ao voltar com sucesso recarrega a lista.
  Future<void> _openLog(BuildContext context, ReleaseEntity release, ReleaseType? type) async {
    final saved = await context.push<bool>('/log/${release.id}');
    if (saved == true && context.mounted) _load(context, type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<ArtistBloc, ArtistState>(
        builder: (context, state) {
          if (state is ArtistFailure) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: StateMessageWidget(
                label: 'ERRO',
                message: state.exception.message,
                actionLabel: 'Tentar de novo',
                onAction: () => _load(context, null),
                isError: true,
              ),
            );
          }

          if (state is ArtistSuccess) {
            return _ArtistContent(
              state: state,
              onTypeSelected: (type) => _load(context, type),
              onOpenRelease: (release) async {
                await context.push('/search/release/${release.id}');
                if (context.mounted) _load(context, state.selectedType);
              },
              onLog: (release) => _openLog(context, release, state.selectedType),
            );
          }

          return const LoadingIndicatorWidget();
        },
      ),
    );
  }
}

class _ArtistContent extends StatelessWidget {
  const _ArtistContent({
    required this.state,
    required this.onTypeSelected,
    required this.onOpenRelease,
    required this.onLog,
  });

  final ArtistSuccess state;
  final ValueChanged<ReleaseType?> onTypeSelected;
  final ValueChanged<ReleaseEntity> onOpenRelease;
  final ValueChanged<ReleaseEntity> onLog;

  ArtistCatalogEntity get catalog => state.catalog;

  @override
  Widget build(BuildContext context) {
    final artist = catalog.artist;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Row(
          children: [
            CoverArtWidget(
              size: 72,
              radius: 999,
              seed: artist.id,
              imageUrl: artist.thumbnailUrl,
              showNoArt: artist.thumbnailUrl == null,
            ),
            const Gap(16),
            Expanded(child: Text(artist.name, style: AppTextStyles.heading)),
          ],
        ),
        const Gap(16),
        SyncStatusBadgeWidget(catalog: catalog),
        if (artist.syncStatus != SyncStatus.idle) const Gap(16),
        _TypeFilter(selected: state.selectedType, onSelected: onTypeSelected),
        const Gap(16),
        if (catalog.releases.isEmpty)
          StateMessageWidget(
            label: catalog.syncPending ? 'CARREGANDO CATÁLOGO' : 'SEM RELEASES',
            message: catalog.syncPending
                ? 'O catálogo deste artista ainda está sendo carregado. Volte em instantes.'
                : 'Nenhum release deste tipo.',
          )
        else
          HairlineCardWidget(
            children: [
              for (final release in catalog.releases)
                ReleaseTileWidget(
                  release: release,
                  onTap: () => onOpenRelease(release),
                  trailing: _EntryAction(
                    entry: state.entries[release.id],
                    onAdd: () => onLog(release),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _TypeFilter extends StatelessWidget {
  const _TypeFilter({required this.selected, required this.onSelected});

  final ReleaseType? selected;
  final ValueChanged<ReleaseType?> onSelected;

  @override
  Widget build(BuildContext context) {
    // `unknown` não tem filtro na API.
    const pluralLabels = {
      ReleaseType.album: 'Álbuns',
      ReleaseType.ep: 'EPs',
      ReleaseType.single: 'Singles',
    };
    const types = [ReleaseType.album, ReleaseType.ep, ReleaseType.single];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChipWidget(label: 'Todos', isSelected: selected == null, onTap: () => onSelected(null)),
          for (final type in types) ...[
            const Gap(8),
            FilterChipWidget(
              label: pluralLabels[type]!,
              isSelected: selected == type,
              onTap: () => onSelected(type),
            ),
          ],
        ],
      ),
    );
  }
}

/// Ação por linha: "+" para registrar, ou o estado do registro existente.
class _EntryAction extends StatelessWidget {
  const _EntryAction({required this.entry, required this.onAdd});

  final UserReleaseEntity? entry;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final current = entry;

    if (current == null) {
      return IconButton(
        onPressed: onAdd,
        tooltip: 'Registrar',
        icon: const Icon(Icons.add, color: AppColors.violet400),
        style: IconButton.styleFrom(
          side: const BorderSide(color: AppColors.iron),
          minimumSize: const Size(36, 36),
        ),
      );
    }

    final rating = current.rating;
    if (current.status == UserReleaseStatus.listened && rating != null) {
      return RatingStarsWidget(rating: rating);
    }

    return MonoLabelWidget(
      current.status.label,
      color: current.status == UserReleaseStatus.listening ? AppColors.violet400 : AppColors.fog,
    );
  }
}

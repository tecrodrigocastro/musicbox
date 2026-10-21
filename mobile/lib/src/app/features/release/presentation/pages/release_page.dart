import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/catalog/presentation/extensions/release_type_label_extension.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';
import 'package:musicbox/src/app/features/library/presentation/extensions/user_release_status_label_extension.dart';
import 'package:musicbox/src/app/features/release/presentation/bloc/release_bloc.dart';
import 'package:musicbox/src/core/DI/dependency_injector.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/utils/date_format.dart';
import 'package:musicbox/src/core/utils/show_snack_bar.dart';
import 'package:musicbox/src/core/widgets/cover_art_widget.dart';
import 'package:musicbox/src/core/widgets/hairline_card_widget.dart';
import 'package:musicbox/src/core/widgets/loading_indicator_widget.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';
import 'package:musicbox/src/core/widgets/rating_stars_widget.dart';
import 'package:musicbox/src/core/widgets/state_message_widget.dart';

class ReleasePage extends StatelessWidget {
  const ReleasePage({super.key, required this.releaseId});

  final String releaseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<ReleaseBloc>()..add(ReleaseLoadRequested(releaseId: releaseId)),
      child: _ReleaseView(releaseId: releaseId),
    );
  }
}

class _ReleaseView extends StatelessWidget {
  const _ReleaseView({required this.releaseId});

  final String releaseId;

  void _reload(BuildContext context) {
    context.read<ReleaseBloc>().add(ReleaseLoadRequested(releaseId: releaseId));
  }

  Future<void> _openLog(BuildContext context) async {
    final saved = await context.push<bool>('/log/$releaseId');
    if (saved == true && context.mounted) _reload(context);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remover registro?'),
        content: const Text(
          'Seu registro (status, nota, data e notas) será apagado. O release continua no catálogo.',
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(false),
            child: const Text('Cancelar'),
          ),
          OutlinedButton(
            onPressed: () => dialogContext.pop(true),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.alertRose,
              side: const BorderSide(color: AppColors.alertRose),
            ),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<ReleaseBloc>().add(ReleaseDeleteRequested(releaseId: releaseId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<ReleaseBloc, ReleaseState>(
        listener: (context, state) {
          if (state is ReleaseDeleteSuccess) {
            showMessageSnackBar(context, 'Registro removido', icon: Icons.check_circle, iconColor: AppColors.violet400);
            _reload(context);
          }
          if (state is ReleaseDeleteFailure) {
            showMessageSnackBar(context, state.exception.message, icon: Icons.error_outline, iconColor: AppColors.alertRose);
          }
        },
        child: BlocBuilder<ReleaseBloc, ReleaseState>(
          // Falha ao remover mantém a tela anterior: só estes estados redesenham.
          buildWhen: (previous, current) => current is ReleaseInitial || current is ReleaseLoading || current is ReleaseLoaded || current is ReleaseFailure,
          builder: (context, state) {
            if (state is ReleaseFailure) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: StateMessageWidget(
                  label: 'ERRO',
                  message: state.exception.message,
                  actionLabel: 'Tentar de novo',
                  onAction: () => _reload(context),
                  isError: true,
                ),
              );
            }

            if (state is ReleaseLoaded) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: [
                  _ReleaseHeader(release: state.release),
                  const Gap(24),
                  const MonoLabelWidget('Meu registro'),
                  const Gap(8),
                  _EntrySection(
                    entry: state.entry,
                    onLog: () => _openLog(context),
                    onDelete: () => _confirmDelete(context),
                  ),
                ],
              );
            }

            return const LoadingIndicatorWidget();
          },
        ),
      ),
    );
  }
}

class _ReleaseHeader extends StatelessWidget {
  const _ReleaseHeader({required this.release});

  final ReleaseEntity release;

  @override
  Widget build(BuildContext context) {
    final year = release.releaseYear;
    final meta = [release.type.label, if (year != null) '$year'].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CoverArtWidget(size: 200, radius: 12, seed: release.id, imageUrl: release.thumbnailUrl),
        ),
        const Gap(20),
        Text(release.title, style: AppTextStyles.heading),
        const Gap(4),
        Text(release.artistNames, style: AppTextStyles.body.copyWith(color: AppColors.fog)),
        const Gap(8),
        MonoLabelWidget(meta),
      ],
    );
  }
}

class _EntrySection extends StatelessWidget {
  const _EntrySection({required this.entry, required this.onLog, required this.onDelete});

  final UserReleaseEntity? entry;
  final VoidCallback onLog;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final current = entry;

    if (current == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const StateMessageWidget(
            label: 'SEM REGISTRO',
            message: 'Você ainda não registrou este release.',
          ),
          const Gap(16),
          FilledButton(onPressed: onLog, child: const Text('Registrar')),
        ],
      );
    }

    final rating = current.rating;
    final listenedAt = current.listenedAt;
    final notes = current.notes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HairlineCardWidget(
          children: [
            _InfoRow(label: 'Status', child: Text(current.status.label, style: AppTextStyles.body)),
            if (current.status == UserReleaseStatus.listened) ...[
              _InfoRow(
                label: 'Data',
                child: Text(
                  listenedAt == null ? '—' : formatIsoDate(listenedAt),
                  style: AppTextStyles.label.copyWith(color: AppColors.ice),
                ),
              ),
              _InfoRow(
                label: 'Nota',
                child: rating == null ? const Text('—', style: AppTextStyles.body) : RatingStarsWidget(rating: rating, size: 16),
              ),
            ],
            _InfoRow(
              label: 'Notas',
              child: Text(
                (notes == null || notes.isEmpty) ? '—' : notes,
                style: AppTextStyles.body,
              ),
            ),
          ],
        ),
        const Gap(16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(onPressed: onLog, child: const Text('Editar')),
            ),
            const Gap(12),
            Expanded(
              child: OutlinedButton(
                onPressed: onDelete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.alertRose,
                  side: const BorderSide(color: AppColors.alertRose),
                ),
                child: const Text('Remover'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 72, child: MonoLabelWidget(label)),
          const Gap(12),
          Expanded(child: Align(alignment: Alignment.centerLeft, child: child)),
        ],
      ),
    );
  }
}

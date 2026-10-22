import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/artist_catalog_entity.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/sync_status.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';

/// Estado da sincronização do catálogo do artista.
///
/// Só `queued` tem desenho no protótipo (âmbar). `running` e `failed` seguem o
/// `DESIGN.md`: andamento em violeta e falha em Alert Rose, só com contorno.
/// `idle` sem pendência não mostra nada.
class SyncStatusBadgeWidget extends StatelessWidget {
  const SyncStatusBadgeWidget({super.key, required this.catalog});

  final ArtistCatalogEntity catalog;

  @override
  Widget build(BuildContext context) {
    final status = catalog.artist.syncStatus;

    final (String, String, Color)? content = switch (status) {
      SyncStatus.queued => (
          'Na fila',
          catalog.syncStale
              ? 'Mostrando o catálogo anterior. Uma atualização está na fila.'
              : 'O catálogo deste artista está na fila para ser carregado.',
          AppColors.signalAmber,
        ),
      SyncStatus.running => (
          'Atualizando',
          catalog.syncStale
              ? 'Mostrando o catálogo anterior. Uma atualização está em andamento.'
              : 'O catálogo deste artista está sendo carregado.',
          AppColors.violet400,
        ),
      SyncStatus.failed => (
          'Falhou',
          'Não foi possível atualizar o catálogo deste artista.',
          AppColors.alertRose,
        ),
      SyncStatus.idle => null,
    };

    if (content == null) return const SizedBox.shrink();
    final (label, message, color) = content;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonoLabelWidget(label, color: color),
          const Gap(12),
          Expanded(child: Text(message, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:musicbox/src/app/features/catalog/domain/entities/release_entity.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/save_user_release_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';
import 'package:musicbox/src/app/features/library/presentation/extensions/user_release_status_label_extension.dart';
import 'package:musicbox/src/app/features/log/presentation/bloc/log_bloc.dart';
import 'package:musicbox/src/app/features/log/presentation/widgets/rating_picker_widget.dart';
import 'package:musicbox/src/core/DI/dependency_injector.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/utils/date_format.dart';
import 'package:musicbox/src/core/utils/show_snack_bar.dart';
import 'package:musicbox/src/core/widgets/cover_art_widget.dart';
import 'package:musicbox/src/core/widgets/loading_indicator_widget.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';
import 'package:musicbox/src/core/widgets/state_message_widget.dart';

/// Registro de um release (modal, sem barra inferior). Fecha com `pop(true)`
/// quando salva, para quem abriu recarregar os dados.
class LogPage extends StatelessWidget {
  const LogPage({super.key, required this.releaseId});

  final String releaseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<LogBloc>()..add(LogLoadRequested(releaseId: releaseId)),
      child: _LogView(releaseId: releaseId),
    );
  }
}

class _LogView extends StatelessWidget {
  const _LogView({required this.releaseId});

  final String releaseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Registrar'),
        actions: [
          IconButton(
            onPressed: () => context.pop(false),
            tooltip: 'Fechar',
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: BlocListener<LogBloc, LogState>(
        listener: (context, state) {
          if (state is LogSaveSuccess) {
            showMessageSnackBar(context, 'Registro salvo', icon: Icons.check_circle, iconColor: AppColors.violet400);
            context.pop(true);
          }
          if (state is LogSaveFailure) {
            showMessageSnackBar(context, state.exception.message, icon: Icons.error_outline, iconColor: AppColors.alertRose);
          }
        },
        child: BlocBuilder<LogBloc, LogState>(
          buildWhen: (previous, current) => current is LogInitial || current is LogLoading || current is LogReady || current is LogLoadFailure,
          builder: (context, state) {
            if (state is LogLoadFailure) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: StateMessageWidget(
                  label: 'ERRO',
                  message: state.exception.message,
                  actionLabel: 'Tentar de novo',
                  onAction: () => context.read<LogBloc>().add(LogLoadRequested(releaseId: releaseId)),
                  isError: true,
                ),
              );
            }

            if (state is LogReady) {
              return _LogForm(release: state.release, initial: state.entry == null ? null : SaveUserReleaseParams.fromEntry(state.entry!), isSaving: state.isSaving);
            }

            return const LoadingIndicatorWidget();
          },
        ),
      ),
    );
  }
}

class _LogForm extends StatefulWidget {
  const _LogForm({required this.release, required this.initial, required this.isSaving});

  final ReleaseEntity release;

  /// Registro existente (edição); `null` para um registro novo.
  final SaveUserReleaseParams? initial;
  final bool isSaving;

  @override
  State<_LogForm> createState() => _LogFormState();
}

class _LogFormState extends State<_LogForm> {
  static const _notesLimit = 5000;

  late final SaveUserReleaseParams _params;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _params = widget.initial ??
        SaveUserReleaseParams(
          releaseId: widget.release.id,
          status: UserReleaseStatus.listened,
          listenedAt: _today(),
        );
    _notesController = TextEditingController(text: _params.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void _setStatus(UserReleaseStatus status) {
    setState(() {
      final wasListened = _params.status == UserReleaseStatus.listened;
      _params.setStatus(status);
      // Voltando para "Ouvi", a data volta a ser hoje (o status anterior a limpou).
      if (status == UserReleaseStatus.listened && !wasListened) {
        _params.setListenedAt(_today());
      }
    });
  }

  Future<void> _pickDate() async {
    final today = _today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _params.listenedAt ?? today,
      firstDate: DateTime(1900),
      // A API recusa datas futuras.
      lastDate: today,
    );
    if (picked != null) {
      setState(() => _params.setListenedAt(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final release = widget.release;
    final isListened = _params.status == UserReleaseStatus.listened;
    final listenedAt = _params.listenedAt;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
          children: [
            CoverArtWidget(size: 56, seed: release.id, imageUrl: release.thumbnailUrl),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(release.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.title),
                  const Gap(2),
                  Text(release.artistNames, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ],
        ),
        const Gap(24),
        const MonoLabelWidget('Status'),
        const Gap(8),
        SegmentedButton<UserReleaseStatus>(
          showSelectedIcon: false,
          segments: [
            for (final status in UserReleaseStatus.values) ButtonSegment(value: status, label: Text(status.label)),
          ],
          selected: {_params.status},
          onSelectionChanged: (selection) => _setStatus(selection.first),
        ),
        if (isListened) ...[
          const Gap(24),
          const MonoLabelWidget('Nota'),
          const Gap(4),
          RatingPickerWidget(
            rating: _params.rating,
            onChanged: (value) => setState(() => _params.setRating(value)),
          ),
          const Gap(16),
          const MonoLabelWidget('Data'),
          const Gap(8),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today_outlined, size: 16),
            label: Text(listenedAt == null ? 'Escolher data' : formatIsoDate(listenedAt)),
          ),
        ],
        const Gap(24),
        const MonoLabelWidget('Notas'),
        const Gap(8),
        TextField(
          controller: _notesController,
          onChanged: (value) => setState(() => _params.setNotes(value)),
          minLines: 4,
          maxLines: 8,
          maxLength: _notesLimit,
          decoration: const InputDecoration(hintText: 'O que você achou? (opcional)'),
        ),
        const Gap(24),
        FilledButton(
          onPressed: widget.isSaving
              ? null
              : () => context.read<LogBloc>().add(
                    LogSaveRequested(
                      // Cópia, para o bloc não ver mudanças feitas depois do toque.
                      params: SaveUserReleaseParams(
                        releaseId: _params.releaseId,
                        status: _params.status,
                        rating: _params.rating,
                        listenedAt: _params.listenedAt,
                        notes: _params.notes,
                      ),
                    ),
                  ),
          child: widget.isSaving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Salvar'),
        ),
        const Gap(8),
        TextButton(
          onPressed: widget.isSaving ? null : () => context.pop(false),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}

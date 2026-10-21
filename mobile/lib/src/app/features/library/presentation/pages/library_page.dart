import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/list_user_releases_params.dart';
import 'package:musicbox/src/app/features/library/domain/entities/sort_direction.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_sort.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_status.dart';
import 'package:musicbox/src/app/features/library/presentation/bloc/library_bloc.dart';
import 'package:musicbox/src/app/features/library/presentation/extensions/user_release_status_label_extension.dart';
import 'package:musicbox/src/app/features/library/presentation/widgets/user_release_tile_widget.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/widgets/filter_chip_widget.dart';
import 'package:musicbox/src/core/widgets/hairline_card_widget.dart';
import 'package:musicbox/src/core/widgets/loading_indicator_widget.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';
import 'package:musicbox/src/core/widgets/state_message_widget.dart';

/// Aba Biblioteca. O [LibraryBloc] vem da `BasePage`, que também o recarrega
/// quando a aba volta a ficar visível.
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) => const _LibraryView();
}

/// Opções de ordenação do menu, com a direção natural de cada campo.
class _SortOption {
  const _SortOption(this.label, this.sort, this.direction);

  final String label;
  final UserReleaseSort sort;
  final SortDirection direction;
}

const _sortOptions = [
  _SortOption('Data de escuta', UserReleaseSort.listenedAt, SortDirection.desc),
  _SortOption('Nota', UserReleaseSort.rating, SortDirection.desc),
  _SortOption('Título', UserReleaseSort.title, SortDirection.asc),
  _SortOption('Ano de lançamento', UserReleaseSort.releaseYear, SortDirection.desc),
];

class _LibraryView extends StatefulWidget {
  const _LibraryView();

  @override
  State<_LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<_LibraryView> {
  UserReleaseStatus? _status;
  _SortOption _sort = _sortOptions.first;

  void _load() {
    context.read<LibraryBloc>().add(
          LibraryLoadRequested(
            params: ListUserReleasesParams(
              status: _status,
              sort: _sort.sort,
              direction: _sort.direction,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          children: [
            const Text('Biblioteca', style: AppTextStyles.heading),
            const Gap(16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChipWidget(
                    label: 'Todos',
                    isSelected: _status == null,
                    onTap: () {
                      setState(() => _status = null);
                      _load();
                    },
                  ),
                  for (final status in UserReleaseStatus.values) ...[
                    const Gap(8),
                    FilterChipWidget(
                      label: status.label,
                      isSelected: _status == status,
                      onTap: () {
                        setState(() => _status = status);
                        _load();
                      },
                    ),
                  ],
                ],
              ),
            ),
            const Gap(16),
            BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MonoLabelWidget(state is LibrarySuccess ? '${state.entries.length} registros' : ' '),
                    PopupMenuButton<_SortOption>(
                      tooltip: 'Ordenar',
                      initialValue: _sort,
                      onSelected: (option) {
                        setState(() => _sort = option);
                        _load();
                      },
                      itemBuilder: (context) => [
                        for (final option in _sortOptions) PopupMenuItem(value: option, child: Text(option.label)),
                      ],
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MonoLabelWidget(_sort.label, color: AppColors.violet400),
                          const Gap(4),
                          const Icon(Icons.arrow_drop_down, size: 18, color: AppColors.violet400),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const Gap(12),
            BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                if (state is LibraryFailure) {
                  return StateMessageWidget(
                    label: 'ERRO',
                    message: state.exception.message,
                    actionLabel: 'Tentar de novo',
                    onAction: _load,
                    isError: true,
                  );
                }

                if (state is LibrarySuccess) {
                  if (state.entries.isEmpty) {
                    return StateMessageWidget(
                      label: 'BIBLIOTECA VAZIA',
                      message: _status == null
                          ? 'Você ainda não registrou nenhum release. Busque um artista para começar.'
                          : 'Nenhum registro com este status.',
                      actionLabel: _status == null ? 'Buscar artista' : null,
                      onAction: _status == null ? () => context.go('/search') : null,
                    );
                  }

                  return HairlineCardWidget(
                    children: [
                      for (final entry in state.entries)
                        UserReleaseTileWidget(
                          entry: entry,
                          onTap: () async {
                            await context.push('/library/release/${entry.releaseId}');
                            if (mounted) _load();
                          },
                        ),
                    ],
                  );
                }

                return const LoadingIndicatorWidget();
              },
            ),
          ],
        ),
      ),
    );
  }
}

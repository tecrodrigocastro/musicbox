import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:musicbox/routes.dart';
import 'package:musicbox/src/app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:musicbox/src/app/features/home/presentation/bloc/home_bloc.dart';
import 'package:musicbox/src/app/features/home/presentation/widgets/new_release_card_widget.dart';
import 'package:musicbox/src/app/features/library/domain/entities/user_release_entity.dart';
import 'package:musicbox/src/app/features/library/presentation/widgets/user_release_tile_widget.dart';
import 'package:musicbox/src/core/DI/dependency_injector.dart';
import 'package:musicbox/src/core/interfaces/usecase_interface.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/utils/date_format.dart';
import 'package:musicbox/src/core/widgets/hairline_card_widget.dart';
import 'package:musicbox/src/core/widgets/loading_indicator_widget.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';
import 'package:musicbox/src/core/widgets/state_message_widget.dart';

/// Aba Início. O [HomeBloc] vem da `BasePage`, que também o recarrega quando
/// a aba volta a ficar visível.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout() async {
    final logoutUsecase = injector<LogoutUsecase>();
    await logoutUsecase.call(NoParams());
    router.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              children: [
                _Header(onLogout: _logout),
                const Gap(24),
                if (state is HomeFailure)
                  StateMessageWidget(
                    label: 'ERRO',
                    message: state.exception.message,
                    actionLabel: 'Tentar de novo',
                    onAction: () => context.read<HomeBloc>().add(HomeLoadRequested()),
                    isError: true,
                  )
                else if (state is HomeSuccess)
                  ..._content(context, state)
                else
                  const LoadingIndicatorWidget(),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context, HomeSuccess state) {
    return [
      const MonoLabelWidget('Ouvindo agora'),
      const Gap(8),
      if (state.listening.isEmpty)
        const StateMessageWidget(
          label: 'NADA POR AQUI',
          message: 'Nenhum release em andamento. Marque um como "Ouvindo".',
        )
      else
        _EntryList(entries: state.listening),
      const Gap(32),
      const MonoLabelWidget('Novos no catálogo'),
      const Gap(8),
      SizedBox(
        height: 192,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: state.newReleases.length,
          separatorBuilder: (context, index) => const Gap(12),
          itemBuilder: (context, index) {
            final release = state.newReleases[index];
            return NewReleaseCardWidget(
              release: release,
              onTap: () => _openRelease(context, release.id),
            );
          },
        ),
      ),
      const Gap(32),
      const MonoLabelWidget('Recentes na sua biblioteca'),
      const Gap(8),
      if (state.recent.isEmpty)
        const StateMessageWidget(
          label: 'BIBLIOTECA VAZIA',
          message: 'Releases que você ouvir aparecem aqui.',
        )
      else
        _EntryList(entries: state.recent),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MonoLabelWidget(formatHeaderDate(DateTime.now())),
              const Gap(8),
              const Text('Início', style: AppTextStyles.heading),
            ],
          ),
        ),
        // Sem release escolhido, "Registrar" leva à busca para achar o artista.
        FilledButton(
          onPressed: () => context.go('/search'),
          child: const Text('Registrar'),
        ),
        IconButton(
          onPressed: onLogout,
          tooltip: 'Sair',
          icon: const Icon(Icons.logout_sharp),
        ),
      ],
    );
  }
}

/// Abre o release e recarrega a Início ao voltar (o registro pode ter mudado).
Future<void> _openRelease(BuildContext context, String releaseId) async {
  final bloc = context.read<HomeBloc>();
  await context.push('/home/release/$releaseId');
  bloc.add(HomeLoadRequested());
}

class _EntryList extends StatelessWidget {
  const _EntryList({required this.entries});

  final List<UserReleaseEntity> entries;

  @override
  Widget build(BuildContext context) {
    return HairlineCardWidget(
      children: [
        for (final entry in entries)
          UserReleaseTileWidget(
            entry: entry,
            onTap: () => _openRelease(context, entry.releaseId),
          ),
      ],
    );
  }
}

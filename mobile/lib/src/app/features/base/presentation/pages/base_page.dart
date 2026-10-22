import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:musicbox/src/app/features/home/presentation/bloc/home_bloc.dart';
import 'package:musicbox/src/app/features/library/domain/dtos/list_user_releases_params.dart';
import 'package:musicbox/src/app/features/library/presentation/bloc/library_bloc.dart';
import 'package:musicbox/src/core/DI/dependency_injector.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';

/// Casca com a barra inferior: Início · Buscar · Biblioteca.
///
/// Os blocos de Início e Biblioteca moram aqui, e não nas páginas, para a barra
/// poder recarregá-los quando a aba volta a ficar visível (um registro salvo
/// em outra aba muda as duas listas).
class BasePage extends StatelessWidget {
  const BasePage({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const _tabs = [
    _TabItem('Início', Icons.home_outlined),
    _TabItem('Buscar', Icons.search),
    _TabItem('Biblioteca', Icons.album_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => injector<HomeBloc>()..add(HomeLoadRequested())),
        BlocProvider(create: (_) => injector<LibraryBloc>()..add(LibraryLoadRequested(params: ListUserReleasesParams()))),
      ],
      child: Scaffold(
        body: shell,
        bottomNavigationBar: Builder(
          builder: (context) => _BottomBar(
            currentIndex: shell.currentIndex,
            tabs: _tabs,
            onTap: (index) => _onTap(context, index),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    if (index != shell.currentIndex) {
      if (index == 0) context.read<HomeBloc>().add(HomeLoadRequested());
      if (index == 2) context.read<LibraryBloc>().add(LibraryRefreshRequested());
    }

    // Tocar na aba já ativa volta para a raiz dela.
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }
}

class _TabItem {
  const _TabItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.currentIndex, required this.tabs, required this.onTap});

  final int currentIndex;
  final List<_TabItem> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.carbon,
        border: Border(top: BorderSide(color: AppColors.iron)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var i = 0; i < tabs.length; i++)
              Expanded(
                child: _BottomBarItem(
                  item: tabs[i],
                  isSelected: i == currentIndex,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({required this.item, required this.isSelected, required this.onTap});

  final _TabItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.violet400 : AppColors.fog;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador de 2px no topo da aba ativa.
            Container(height: 2, color: isSelected ? AppColors.violet600 : Colors.transparent),
            const SizedBox(height: 10),
            Icon(item.icon, size: 22, color: color),
            const SizedBox(height: 6),
            MonoLabelWidget(item.label, color: color),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

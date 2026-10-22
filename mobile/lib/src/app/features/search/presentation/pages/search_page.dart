import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:musicbox/src/app/features/catalog/domain/dtos/search_artists_params.dart';
import 'package:musicbox/src/app/features/catalog/presentation/widgets/artist_tile_widget.dart';
import 'package:musicbox/src/app/features/search/presentation/bloc/search_bloc.dart';
import 'package:musicbox/src/core/DI/dependency_injector.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/widgets/hairline_card_widget.dart';
import 'package:musicbox/src/core/widgets/loading_indicator_widget.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';
import 'package:musicbox/src/core/widgets/state_message_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<SearchBloc>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  static const _debounce = Duration(milliseconds: 400);

  final _controller = TextEditingController();
  final SearchArtistsParams _params = SearchArtistsParams.empty();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _timer?.cancel();
    _params.setQuery(value);

    // Abaixo de 2 caracteres a API recusa a busca: volta ao estado inicial.
    if (_params.query.length < 2) {
      context.read<SearchBloc>().add(SearchCleared());
      return;
    }

    _timer = Timer(_debounce, _search);
  }

  void _search() {
    context.read<SearchBloc>().add(SearchRequested(params: SearchArtistsParams(query: _params.query)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          children: [
            const Text('Buscar', style: AppTextStyles.heading),
            const Gap(16),
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              onSubmitted: (_) {
                _timer?.cancel();
                if (_params.query.length >= 2) _search();
              },
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Nome do artista',
                prefixIcon: Icon(Icons.search, size: 20),
              ),
            ),
            const Gap(24),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) return const LoadingIndicatorWidget();

                if (state is SearchFailure) {
                  return StateMessageWidget(
                    label: 'ERRO',
                    message: state.exception.message,
                    actionLabel: 'Tentar de novo',
                    onAction: _search,
                    isError: true,
                  );
                }

                if (state is SearchSuccess) {
                  if (state.artists.isEmpty) {
                    return const StateMessageWidget(
                      label: 'SEM RESULTADOS',
                      message: 'Nenhum artista encontrado. Tente outro nome.',
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MonoLabelWidget('Candidatos'),
                      const Gap(8),
                      HairlineCardWidget(
                        children: [
                          for (final artist in state.artists)
                            ArtistTileWidget(
                              artist: artist,
                              onTap: () => context.push('/search/artist/${artist.id}'),
                            ),
                        ],
                      ),
                      const Gap(12),
                      const Text(
                        'A busca só lista candidatos. Escolha o artista certo manualmente.',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  );
                }

                return const StateMessageWidget(
                  label: 'BUSCAR',
                  message: 'Digite ao menos 2 caracteres para procurar um artista.',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

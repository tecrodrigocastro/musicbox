import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musicbox/src/app/features/artist/presentation/pages/artist_page.dart';
import 'package:musicbox/src/app/features/auth/presentation/pages/login_page.dart';
import 'package:musicbox/src/app/features/base/presentation/pages/base_page.dart';
import 'package:musicbox/src/app/features/home/presentation/pages/home_page.dart';
import 'package:musicbox/src/app/features/library/presentation/pages/library_page.dart';
import 'package:musicbox/src/app/features/log/presentation/pages/log_page.dart';
import 'package:musicbox/src/app/features/release/presentation/pages/release_page.dart';
import 'package:musicbox/src/app/features/search/presentation/pages/search_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Sub-rotas de release. Cada aba tem a sua para a barra inferior continuar
/// visível e a aba de origem continuar ativa (o protótipo mantém "Buscar"
/// ativa nas telas de artista e release).
GoRoute _releaseRoute() => GoRoute(
      path: 'release/:releaseId',
      builder: (context, state) => ReleasePage(releaseId: state.pathParameters['releaseId']!),
    );

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => BasePage(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
              routes: [_releaseRoute()],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchPage(),
              routes: [
                GoRoute(
                  path: 'artist/:artistId',
                  builder: (context, state) => ArtistPage(artistId: state.pathParameters['artistId']!),
                ),
                _releaseRoute(),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryPage(),
              routes: [_releaseRoute()],
            ),
          ],
        ),
      ],
    ),
    // Registro é modal: sem barra inferior, fecha com ✕ e devolve `true` ao salvar.
    GoRoute(
      path: '/log/:releaseId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => LogPage(releaseId: state.pathParameters['releaseId']!),
    ),
    GoRoute(path: '/', builder: (context, state) => const Placeholder()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
  ],
);

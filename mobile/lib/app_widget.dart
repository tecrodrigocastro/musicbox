import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbox/routes.dart';
import 'package:musicbox/src/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:musicbox/src/core/DI/dependency_injector.dart';
import 'package:musicbox/src/core/theme/app_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => injector<AuthBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'MusicBox',
        theme: AppTheme.dark,
        routerConfig: router,
      ),
    );
  }
}

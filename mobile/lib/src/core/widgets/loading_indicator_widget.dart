import 'package:flutter/material.dart';

/// Indicador de carregamento centralizado, com folga vertical para ocupar o
/// lugar de uma lista enquanto os dados chegam.
class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

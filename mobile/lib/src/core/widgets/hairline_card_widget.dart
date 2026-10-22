import 'package:flutter/material.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';

/// Card Graphite de 12px de raio com borda Iron de 1px e divisórias de 1px
/// entre os filhos. É a "tabela" do app: uma lista de linhas sem sombra.
///
/// Usa [Material] (e não um `Container` com cor) para que o efeito de toque
/// dos `InkWell` das linhas continue visível por cima do fundo.
class HairlineCardWidget extends StatelessWidget {
  const HairlineCardWidget({
    super.key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.background = AppColors.graphite,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.iron),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: AppColors.iron),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

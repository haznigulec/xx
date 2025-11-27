import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class SymbolDividendHistoryHeaderWidget extends StatelessWidget {
  final String title1;
  final String title2;
  final String title3;

  const SymbolDividendHistoryHeaderWidget({
    super.key,
    required this.title1,
    required this.title2,
    required this.title3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.s + Grid.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title1,
                  style: context.pAppStyle.labelMed12textSecondary,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  title2,
                  style: context.pAppStyle.labelMed12textSecondary,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  title3,
                  style: context.pAppStyle.labelMed12textSecondary,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const PDivider(),
      ],
    );
  }
}

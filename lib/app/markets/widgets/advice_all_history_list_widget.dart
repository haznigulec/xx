import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/markets/widgets/advice_history_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class AdviceAllHistoryListPage extends StatelessWidget {
  final String mainGroup;
  const AdviceAllHistoryListPage({
    super.key,
    required this.mainGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('advices_history'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: SingleChildScrollView(
          child: AdviceHistoryWidget(
            mainGroup: mainGroup,
          ),
        ),
      ),
    );
  }
}

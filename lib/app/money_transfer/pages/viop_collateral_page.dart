import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/money_transfer/pages/deposit_collateral_page.dart';
import 'package:piapiri_v2/app/money_transfer/pages/withdrawal_collateral_page.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class ViopCollateralPage extends StatefulWidget {
  const ViopCollateralPage({super.key});

  @override
  State<ViopCollateralPage> createState() => _ViopCollateralPageState();
}

class _ViopCollateralPageState extends State<ViopCollateralPage> {
  int _selectedSegmentedIndex = 0;
  bool _hasFocus = false;
  bool isClickAllSelectLimit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('portfolio.viop_collateral'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: Grid.l - Grid.xs,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 35,
              child: SlidingSegment(
                backgroundColor: context.pColorScheme.card,
                segmentList: [
                  PSlidingSegmentModel(
                    segmentTitle: L10n.tr('teminat_yatirma'),
                    segmentColor: context.pColorScheme.secondary,
                  ),
                  PSlidingSegmentModel(
                    segmentTitle: L10n.tr('teminat_cekme'),
                    segmentColor: context.pColorScheme.secondary,
                  ),
                ],
                onValueChanged: (index) {
                  setState(() {
                    _selectedSegmentedIndex = index;
                    _hasFocus = false;
                  });
                },
              ),
            ),
            const SizedBox(
              height: Grid.l,
            ),
            Expanded(
              child: _selectedSegmentedIndex == 0
                  ? const DepositCollateralPage()
                  : WithDrawalCollateralPage(
                      onFocusChanged: (focus) {
                        setState(() => _hasFocus = focus);
                      },
                      isTapAllSelectLimit: isClickAllSelectLimit,
                    ),
            )
          ],
        ),
      ),
      bottomSheet: _hasFocus
          ? ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Grid.m,
                    right: Grid.m,
                    bottom: Grid.xxl + Grid.s,
                  ),
                  child: POutlinedButton(
                    text: L10n.tr('allSelectCollateral'),
                    fillParentWidth: true,
                    onPressed: () {
                      setState(() {
                        isClickAllSelectLimit = true;
                      });
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (mounted) {
                          setState(() {
                            isClickAllSelectLimit = false;
                          });
                        }
                      });
                    },
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

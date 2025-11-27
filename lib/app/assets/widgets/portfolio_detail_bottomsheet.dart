import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/app/assets/widgets/bottomsheet_cash_widget.dart';
import 'package:piapiri_v2/app/assets/widgets/bottomsheet_components_widget.dart';
import 'package:piapiri_v2/app/assets/widgets/portfolio_bottomsheet_title.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PortfolioDetailBottomSheet extends StatefulWidget {
  final OverallItemModel assets;
  final bool isVisible;
  final bool hasViop;
  final bool isDefaultParity;
  final Function(bool) onDefaultParity;
  final double totalUsdOverall;
  final bool? isAgreementPage;
  const PortfolioDetailBottomSheet({
    super.key,
    required this.assets,
    required this.isVisible,
    required this.hasViop,
    required this.isDefaultParity,
    required this.onDefaultParity,
    required this.totalUsdOverall,
    this.isAgreementPage = false,
  });

  @override
  State<PortfolioDetailBottomSheet> createState() => _PortfolioDetailBottomSheetState();
}

class _PortfolioDetailBottomSheetState extends State<PortfolioDetailBottomSheet> {
  bool _isDefaultParity = true;
  late AssetsBloc _assetsBloc;

  @override
  void initState() {
    _isDefaultParity = widget.isDefaultParity;
    _assetsBloc = getIt<AssetsBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AssetsBloc, AssetsState>(
      bloc: _assetsBloc,
      builder: (context, state) {
        if (state.isLoading || state.allCashFlowList == null || state.allCashFlowList!.isEmpty) {
          return const PLoading();
        }
        List<Map<String, dynamic>> titles = [];
        if (state.allCashFlowList != null && state.allCashFlowList!.isNotEmpty) {
          titles.add({
            'title': L10n.tr('current'),
            'description': L10n.tr('description_current'),
            'amount': state.allCashFlowList![0]['cashValue'] ?? 0,
          });
        }
        if (state.allCashFlowList != null && state.allCashFlowList!.length >= 2 && state.allCashFlowList![1] != null) {
          titles.add({
            'title': L10n.tr('current_T1'),
            'description': L10n.tr('description_current_T1'),
            'amount': state.allCashFlowList![1]['cashValue'] ?? 0,
          });
        }
        if (state.allCashFlowList != null && state.allCashFlowList!.length >= 3 && state.allCashFlowList![2] != null) {
          titles.add({
            'title': L10n.tr('current_T2'),
            'description': L10n.tr('description_current_T2'),
            'amount': state.allCashFlowList![2]['cashValue'] ?? 0
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            PortfolioBottomsheetTitle(
              hasViop: widget.hasViop,
              isVisible: widget.isVisible,
              assets: widget.assets,
              totalUsdOverall: widget.totalUsdOverall,
              assetsState: state,
              isAgreementPage: widget.isAgreementPage,
              onDefaultParity: (isDefaultParity) {
                setState(() {
                  _isDefaultParity = isDefaultParity;
                });
              },
            ),
            if (widget.assets.instrumentCategory == 'viop_collateral' && !widget.isAgreementPage! && !widget.hasViop)
              Align(
                alignment: Alignment.centerRight,
                child: PTextButtonWithIcon(
                  text: L10n.tr('teminat_cek_yatir'),
                  iconAlignment: IconAlignment.end,
                  sizeType: PButtonSize.small,
                  padding: EdgeInsets.zero,
                  icon: SvgPicture.asset(
                    ImagesPath.arrow_up_right,
                    width: Grid.m - Grid.xxs,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {
                    router.push(
                      const ViopCollateralRoute(),
                    );
                  },
                ),
              ),
            if ((widget.assets.instrumentCategory != 'viop_collateral') ||
                widget.assets.instrumentCategory == 'viop_collateral' && widget.hasViop)
              const PDivider(),
            if (state.allCashFlowList != null &&
                state.allCashFlowList!.isNotEmpty &&
                widget.assets.instrumentCategory == 'cash') ...[
              BottomsheetCashWidget(
                isVisible: widget.isVisible,
                titles: widget.isAgreementPage! ? [] : titles,
                isDefaultParity: _isDefaultParity,
                totalUsdOverall: widget.totalUsdOverall,
              ),
            ],
            if (widget.assets.instrumentCategory != 'cash' &&
                (widget.assets.instrumentCategory != 'viop_collateral' ||
                    widget.assets.instrumentCategory == 'viop_collateral' && widget.hasViop)) ...[
              Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .5),
                child: BottomsheetComponentsWidget(
                  isVisible: widget.isVisible,
                  assets: widget.assets.instrumentCategory == 'viop_collateral' &&
                          widget.hasViop &&
                          state.portfolioViop != null
                      ? state.portfolioViop!
                      : widget.assets,
                  isDefaultParity: _isDefaultParity,
                  totalUsdOverall: widget.totalUsdOverall,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

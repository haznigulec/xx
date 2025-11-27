import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/app/home/widgets/rotating_loading_indicator.dart';
import 'package:piapiri_v2/app/home/widgets/shimmer_account_status.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AccountStatus extends StatefulWidget {
  const AccountStatus({
    super.key,
  });

  @override
  State<AccountStatus> createState() => _AccountStatusState();
}

class _AccountStatusState extends State<AccountStatus> {
  late AssetsBloc _assetsBloc;

  @override
  void initState() {
    _assetsBloc = getIt<AssetsBloc>();
    if (UserModel.instance.alpacaAccountStatus) {
      _assetsBloc.add(
        GetCapraPortfolioSummaryEvent(),
      );
    }

    _assetsBloc.add(
      GetOverallSummaryEvent(
        accountId: '',
        allAccounts: true,
        includeCashFlow: true,
        getInstant: true,
        includeCreditDetail: true,
        calculateTradeLimit: true,
        isConsolidated: true,
        isShowTotalAsset: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AssetsBloc, AssetsState>(
      bloc: _assetsBloc,
      builder: (context, state) {
        final bool isPortfolioSummaryReady =
            state.usPortfolioState == PageState.success || !UserModel.instance.alpacaAccountStatus;

        if ((state.totalAsset == null && isPortfolioSummaryReady) || state.consolidatedAssets == null) {
          //show case'in itemı doğru işaretleyebilmesi için yükseklik olmak zorunda.
          //loading bitince sayfa aşağı kayarsa, show case göstergesi eski bölgede kalıyor.
          return const SizedBox(
            height: 76,
            child: Shimmerize(
              enabled: true,
              child: ShimmerAccountStatus(),
            ),
          );
        }

        return ValueListenableBuilder(
          valueListenable: UserModel.instance.showTotalAsset,
          builder: (context, isShowing, child) => SizedBox(
            //show case'in itemı doğru işaretleyebilmesi için yükseklik olmak zorunda.
            //loading bitince sayfa aşağı kayarsa, show case göstergesi eski bölgede kalıyor.
            height: 76,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      L10n.tr('my_total_asset'),
                      style: context.pAppStyle.labelReg14textSecondary,
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    state.consolidateAssetState == PageState.loading
                        ? const RotatingLoadingIcon()
                        : InkWell(
                            onTap: state.consolidateAssetState == PageState.loading
                                ? null
                                : () {
                                    _assetsBloc.add(
                                      HasRefreshEvent(true),
                                    );
                                    if (UserModel.instance.alpacaAccountStatus) {
                                      _assetsBloc.add(
                                        GetCapraPortfolioSummaryEvent(),
                                      );
                                      _assetsBloc.add(
                                        GetCapraCollateralInfoEvent(),
                                      );
                                    }
                                    _assetsBloc.add(
                                      GetOverallSummaryEvent(
                                        accountId: '',
                                        allAccounts: true,
                                        includeCashFlow: true,
                                        getInstant: true,
                                        includeCreditDetail: true,
                                        calculateTradeLimit: true,
                                        isConsolidated: true,
                                        isShowTotalAsset: true,
                                      ),
                                    );
                                    _assetsBloc.add(
                                      GetAssetsCollateralInfoEvent(
                                        accountId: UserModel.instance.accountId,
                                      ),
                                    );
                                    _assetsBloc.add(
                                      GetLimitInfosEvent(
                                        accountExtId: UserModel.instance.accountId,
                                      ),
                                    );
                                  },
                            child: SvgPicture.asset(
                              ImagesPath.refresh,
                              width: Grid.m,
                              height: Grid.m,
                              colorFilter: ColorFilter.mode(
                                context.pColorScheme.textTeritary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        isShowing
                            ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                (state.totalAsset ?? 0) +
                                    (state.portfolioSummaryModel == null ||
                                            state.portfolioSummaryModel?.overallItemGroups == null ||
                                            state.portfolioSummaryModel!.overallItemGroups!.isEmpty
                                        ? 0
                                        : state.portfolioSummaryModel!.overallItemGroups!.fold(
                                            0,
                                            (previousValue, element) =>
                                                previousValue +
                                                (state.portfolioSummaryModel!.tlExchangeRate == 1
                                                    ? ((element.totalAmount ?? 0) *
                                                        (state.consolidatedAssets?.totalUsdOverall ?? 1))
                                                    : element.exchangeValue ?? 0),
                                          )),
                              )}'
                            : '${CurrencyEnum.turkishLira.symbol}****',
                        maxLines: 1,
                        style: context.pAppStyle.labelMed34textPrimary.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                    PIconButton(
                      type: PIconButtonType.standard,
                      svgPath: isShowing ? ImagesPath.eye_on : ImagesPath.eye_off,
                      onPressed: () => UserModel.instance.setShowTotalAsset = !isShowing,
                      color: context.pColorScheme.transparent,
                      sizeType: PIconButtonSize.xl,
                    ),
                  ],
                ),
                Text(
                  isShowing
                      ? '≈ ${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                          (state.totalAsset ?? 0) / (state.consolidatedAssets?.totalUsdOverall ?? 1) +
                              (state.portfolioSummaryModel == null ||
                                      state.portfolioSummaryModel?.overallItemGroups == null ||
                                      state.portfolioSummaryModel!.overallItemGroups!.isEmpty
                                  ? 0
                                  : state.portfolioSummaryModel!.overallItemGroups!.fold(
                                      0,
                                      (previousValue, element) => previousValue + (element.totalAmount ?? 0),
                                    )),
                        )}'
                      : '≈ ${CurrencyEnum.dollar.symbol}****',
                  style: context.pAppStyle.labelMed14textPrimary,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

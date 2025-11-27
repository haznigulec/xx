import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/charts/stacked_bar_chart.dart';
import 'package:piapiri_v2/common/widgets/charts/model/stacked_bar_model.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/switch_tile/switch_tile.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/app/assets/model/portfolio_action_enum.dart';
import 'package:piapiri_v2/app/assets/widgets/assets_list.dart';
import 'package:piapiri_v2/app/assets/widgets/calculate_value.dart';
import 'package:piapiri_v2/app/assets/widgets/trade_info_widget.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class AssetsPage extends StatefulWidget {
  final PortfolioActionEnum action;
  final bool isVisible;

  const AssetsPage({
    super.key,
    required this.action,
    required this.isVisible,
  });

  @override
  AssetsPageState createState() => AssetsPageState();
}

class AssetsPageState extends State<AssetsPage> {
  bool _isConsolidated = true;
  String _selectedAccount = '';
  List<String> _accountItemList = [];
  late AssetsBloc _assetsBloc;
  late IpoBloc _ipoBloc;
  @override
  void initState() {
    _assetsBloc = getIt<AssetsBloc>();
    _ipoBloc = getIt<IpoBloc>();
    if (_ipoBloc.state.ipoDemandList == null) {
      _ipoBloc.add(
        GetActiveDemandsEvent(),
      );
    }
    _preparePage();
    super.initState();
  }

  Future<void> _preparePage() async {
    List<AccountModel> accountList = UserModel.instance.accounts;

    _accountItemList = [
      '',
      ...accountList.map(
        (e) => e.accountId.toString(),
      ),
    ];
    String accountExtId = _selectedAccount.isNotEmpty
        ? _selectedAccount.split('-')[1]
        : accountList[0].accountId.toString().split('-')[1];
    _assetsBloc.add(
      GetAssetsCollateralInfoEvent(
        accountId: accountExtId,
      ),
    );
    _assetsBloc.add(
      GetLimitInfosEvent(
        accountExtId: accountExtId,
      ),
    );

    if (_assetsBloc.state.ipoStatus!) {
      _ipoBloc.add(
        GetActiveDemandsEvent(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AssetsBloc, AssetsState>(
      bloc: _assetsBloc,
      builder: (context, state) {
        if (state.hasRefresh != null && state.hasRefresh!) {
          _selectedAccount = L10n.tr('tum_hesaplar');
          _assetsBloc.add(
            HasRefreshEvent(false),
          );
        }
        return SingleChildScrollView(
          child: Shimmerize(
            enabled: state.consolidatedAssets == null,
            child: Column(
              children: [
                if (widget.action == PortfolioActionEnum.domestic) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: Grid.m,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        PCustomOutlinedButtonWithIcon(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          text: L10n.tr(_selectedAccount.isEmpty ? 'tum_hesaplar' : _selectedAccount),
                          iconSource: ImagesPath.chevron_down,
                          onPressed: () async {
                            await PBottomSheet.show(
                              context,
                              titlePadding: const EdgeInsets.only(
                                top: Grid.m,
                              ),
                              title: L10n.tr('account_selection'),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: _accountItemList.length,
                                itemBuilder: (context, index) {
                                  final entry = _accountItemList[index];
                                  return BottomsheetSelectTile(
                                    isSelected: (entry == _selectedAccount ||
                                        (entry == '' && _selectedAccount == L10n.tr('tum_hesaplar'))),
                                    title: entry == '' ? L10n.tr('tum_hesaplar') : entry,
                                    onTap: (selectedAccount, value) {
                                      setState(
                                        () {
                                          _selectedAccount = selectedAccount;
                                          router.maybePop();
                                        },
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) => const PDivider(),
                              ),
                            );
                            if (_selectedAccount.isNotEmpty) {
                              setState(
                                () {
                                  getIt<AppInfo>().selectedAccount = _selectedAccount;
                                  _selectedAccount = _selectedAccount;

                                  _assetsBloc.add(
                                    GetOverallSummaryEvent(
                                      accountId:
                                          _selectedAccount.isNotEmpty && _selectedAccount != L10n.tr('tum_hesaplar')
                                              ? _selectedAccount.split('-')[1]
                                              : '',
                                      allAccounts: _selectedAccount == '',
                                      isConsolidated: _isConsolidated,
                                      includeCashFlow: true,
                                    ),
                                  );

                                  _assetsBloc.add(
                                    GetLimitInfosEvent(
                                      accountExtId:
                                          _selectedAccount.isEmpty || _selectedAccount == L10n.tr('tum_hesaplar')
                                              ? UserModel.instance.accountId
                                              : _selectedAccount.split('-')[1],
                                    ),
                                  );

                                  _assetsBloc.add(
                                    GetAssetsCollateralInfoEvent(
                                      accountId: _selectedAccount.isEmpty || _selectedAccount == L10n.tr('tum_hesaplar')
                                          ? UserModel.instance.accountId
                                          : _selectedAccount.split('-')[1],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        PSwitchRow(
                          text: L10n.tr('konsolide'),
                          value: _isConsolidated,
                          textStyle: context.pAppStyle.labelReg14textPrimary,
                          rowBetweenPadding: Grid.xs,
                          onChanged: (value) {
                            setState(
                              () {
                                _isConsolidated = !_isConsolidated;
                                _assetsBloc.add(
                                  GetOverallSummaryEvent(
                                    accountId: _selectedAccount.isEmpty || _selectedAccount == L10n.tr('tum_hesaplar')
                                        ? ''
                                        : _selectedAccount.split('-')[1],
                                    isConsolidated: _isConsolidated,
                                    allAccounts:
                                        _selectedAccount.isEmpty || _selectedAccount == L10n.tr('tum_hesaplar'),
                                    includeCashFlow: true,
                                    includeCreditDetail: true,
                                    calculateTradeLimit: true,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          L10n.tr('total_asset'),
                          style: context.pAppStyle.labelReg14textSecondary,
                        ),
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.end,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            text: TextSpan(
                              style: context.pAppStyle.labelMed14textPrimary,
                              children: [
                                TextSpan(
                                    text: widget.isVisible
                                        ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                            state.consolidatedAssets != null
                                                ? calculateTotalAmount(state.consolidatedAssets!.overallItemGroups)
                                                : 0,
                                          )} '
                                        : '${CurrencyEnum.turkishLira.symbol}****'),
                                TextSpan(
                                  text: widget.isVisible
                                      ? '≈${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                          state.consolidatedAssets != null
                                              ? calculateTotalAmount(state.consolidatedAssets!.overallItemGroups) /
                                                  (state.consolidatedAssets!.totalUsdOverall)
                                              : 0,
                                        )}'
                                      : '${CurrencyEnum.dollar.symbol}****',
                                  style: context.pAppStyle.labelMed14textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Grid.l / 2,
                    ),
                    StackedBarChart(
                      charDataList: state.consolidatedAssets != null
                          ? _generateChartModel(state.consolidatedAssets!.overallItemGroups)
                          : [],
                    ),
                    const SizedBox(
                      height: Grid.l / 2,
                    ),
                    AssetsList(
                      isVisible: widget.isVisible,
                      assets: state.consolidatedAssets,
                      selectedAccount: _selectedAccount,
                      hasViop: state.portfolioViop?.overallSubItems != null &&
                          state.portfolioViop!.overallSubItems.isNotEmpty,
                      assetSelectedAccount: _selectedAccount,
                      hasIpo: state.ipoStatus ?? false,
                    ),
                    const SizedBox(
                      height: Grid.m,
                    ),
                    TradeInfoCard(
                      isVisible: widget.isVisible,
                    ),
                    const SizedBox(height: Grid.xl),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<StackedBarModel> _generateChartModel(List<OverallItemModel> data) {
    List<StackedBarModel> chartData = [];

    data.removeWhere((e) => e.instrumentCategory == 'viop');

    data.sort((a, b) {
      int getPriority(dynamic asset) {
        if (asset.instrumentCategory == 'cash' && asset.totalAmount != 0) return 0;
        if (asset.instrumentCategory == 'equity') return 1;
        if (asset.instrumentCategory == 'viop_collateral' && asset.totalAmount != 0) return 2;
        if (asset.instrumentCategory == 'fund') return 4;
        if ((asset.instrumentCategory == 'cash' || asset.instrumentCategory == 'viop_collateral') &&
            asset.totalAmount == 0) {
          return 99; // Listenin en sonunda olacaklar
        }
        return 5; // Diğer tüm kategoriler
      }

      return getPriority(a).compareTo(getPriority(b));
    });

    //portfolio bar color
    for (var i = 0; i < data.length; i++) {
      if (data[i].ratio.abs() != 0) {
        chartData.add(
          StackedBarModel(
            percent: data[i].ratio.abs(),
            color: context.pColorScheme.assetColors[i],
          ),
        );
      }
    }

    return chartData;
  }
}

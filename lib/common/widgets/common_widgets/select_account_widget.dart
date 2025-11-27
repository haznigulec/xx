import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/cashflow_transaction_widget.dart';
import 'package:piapiri_v2/common/widgets/list/select_account_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SelectAccountWidget extends StatefulWidget {
  final Function(String) onSelectedAccount;
  final Function(double)? onAmount;
  final String? fundCode;
  final Function()? setFundCodeToAssetCode;
  final String? tradeLimitType;
  const SelectAccountWidget({
    super.key,
    required this.onSelectedAccount,
    this.onAmount,
    this.fundCode = '',
    this.setFundCodeToAssetCode,
    this.tradeLimitType = 'EQUITY-T2',
  });

  @override
  State<SelectAccountWidget> createState() => _SelectAccountWidgetState();
}

class _SelectAccountWidgetState extends State<SelectAccountWidget> {
  double _totalAmount = 0;
  String _selectedAccount = '';
  List _accountList = [];
  final AssetsBloc _assetsBloc = getIt<AssetsBloc>();
  final AppInfo _appInfo = getIt<AppInfo>();
  final AppSettingsBloc _appSettingsBloc = getIt<AppSettingsBloc>();

  @override
  void initState() {
    _selectedAccount = _appInfo.selectedAccount.isNotEmpty
        ? '${_appInfo.selectedAccount.split('-')[0]}-${_appSettingsBloc.state.orderSettings.fundDefaultAccount}'
        : '';

    _accountList = _appInfo.accountList.where((item) => item['currencyType'] == 'TRY').toList();
    _getAssets(_selectedAccount);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AssetsBloc, AssetsState>(
      bloc: _assetsBloc,
      builder: (context, assetsState) {
        if (assetsState.isLoading) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _accountList.length < 2
                ? Padding(
                    padding: const EdgeInsets.only(
                      bottom: Grid.s,
                    ),
                    child: Text(
                      _selectedAccount,
                      style: context.pAppStyle.labelMed14textPrimary,
                    ),
                  )
                : PTextButtonWithIcon(
                    text: _selectedAccount,
                    sizeType: PButtonSize.small,
                    iconAlignment: IconAlignment.end,
                    variant: PButtonVariant.brand,
                    padding: EdgeInsets.zero,
                    icon: SvgPicture.asset(
                      ImagesPath.chevron_down,
                      width: 17,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      PBottomSheet.show(
                        context,
                        title: L10n.tr('account_selection'),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _accountList.length,
                            itemBuilder: (context, index) {
                              return SelectAccountTile(
                                index: index,
                                lastIndex: _accountList.length - 1,
                                selectedAccount: _selectedAccount,
                                accountObject: _accountList[index],
                                onTap: () {
                                  setState(() {
                                    _selectedAccount = _accountList[index]['accountExtId'];
                                  });

                                  _getAssets(_selectedAccount);
                                  widget.onSelectedAccount(_selectedAccount);
                                  router.maybePop();
                                },
                              );
                            }),
                      );
                    },
                  ),
            CashflowTransactionWidget(
              cashValue: _totalAmount,
              limitValue: assetsState.limitInfos?['tradeLimit'] ?? 0,
            ),
          ],
        );
      },
    );
  }

  void _getAssets(String selectedAccount) {
    _assetsBloc.add(
      GetOverallSummaryEvent(
        accountId: selectedAccount.isNotEmpty
            ? selectedAccount.split('-')[1]
            : _appInfo.selectedAccount.isNotEmpty
                ? _appInfo.selectedAccount.split('-')[1]
                : '',
        allAccounts: true,
        includeCashFlow: true,
        includeCreditDetail: true,
        calculateTradeLimit: true,
        isConsolidated: true,
        getInstant: true,
        fundSymbol: widget.fundCode,
        callback: (assetsModel) {
          widget.setFundCodeToAssetCode?.call();
          setState(() {
            if (assetsModel.overallItemGroups.any((e) => e.instrumentCategory == 'cash')) {
              _totalAmount = assetsModel.overallItemGroups
                  .firstWhere((e) => e.instrumentCategory == 'cash')
                  .overallSubItems[0]
                  .amount;
            }
          });
        },
      ),
    );
    _assetsBloc.add(
      GetLimitInfosEvent(
        accountExtId: selectedAccount.isNotEmpty
            ? selectedAccount.split('-')[1]
            : _appInfo.selectedAccount.isNotEmpty
                ? _appInfo.selectedAccount.split('-')[1]
                : '',
        typeName: widget.tradeLimitType,
        calback: (limitInfos) {
          setState(() {
            widget.onAmount?.call(
              limitInfos?['tradeLimit'] ?? 0,
            );
          });
        },
      ),
    );
  }
}

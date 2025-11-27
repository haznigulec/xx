import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/consistent_equivalence.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_add_data_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/app/ipo/pages/ipo_blockage_list_bottom_sheet.dart';
import 'package:piapiri_v2/app/ipo/utils/ipo_constant.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/list/p_symbol_tile.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IpoUpdateWidget extends StatefulWidget {
  final IpoDemandModel myDemandedIpo;
  final String symbolCompanyName;

  const IpoUpdateWidget({
    super.key,
    required this.myDemandedIpo,
    required this.symbolCompanyName,
  });

  @override
  State<IpoUpdateWidget> createState() => _IpoUpdateWidgetState();
}

class _IpoUpdateWidgetState extends State<IpoUpdateWidget> {
  final TextEditingController _orderUnitTC = TextEditingController();
  late final FocusNode _orderFocus;
  bool _orderHasFocus = false;
  double _amount = 0;
  late IpoBloc _ipoBloc;
  List<Map<String, dynamic>>? _itemsToBlock;

  @override
  void initState() {
    _ipoBloc = getIt<IpoBloc>();
    _orderFocus = FocusNode()..addListener(_focusListener);
    _orderUnitTC.text = widget.myDemandedIpo.unitsDemanded!.toInt().toString();
    _amount = (widget.myDemandedIpo.unitsDemanded ?? 0) * (widget.myDemandedIpo.offerPrice ?? 0);
    _ipoBloc.add(
      GetTradeLimitEvent(
        customerId: widget.myDemandedIpo.accountExtId!.split('-')[0],
        accountId: widget.myDemandedIpo.accountExtId!.split('-')[1],
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _orderFocus.removeListener(_focusListener);
    _orderFocus.dispose();
    super.dispose();
  }

  _focusListener() {
    final hasFocus = _orderFocus.hasFocus;
    if (hasFocus != _orderHasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _orderHasFocus = hasFocus;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    (String, int) selectedPaymentType = _paymentType(
      widget.myDemandedIpo.detail ?? '',
    );

    return Column(
      children: [
        PSymbolTile(
          variant: PSymbolVariant.equityTab,
          symbolName: widget.myDemandedIpo.name ?? '',
          subTitle: widget.symbolCompanyName,
          symbolType: SymbolTypes.equity,
          title: widget.myDemandedIpo.name,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
          child: PDivider(),
        ),
        Row(
          children: [
            Text(
              '${L10n.tr('ipo_price')}: ',
              style: context.pAppStyle.labelMed12textSecondary,
            ),
            const SizedBox(
              width: Grid.xs,
            ),
            Text(
              '₺${MoneyUtils().readableMoney(widget.myDemandedIpo.offerPrice ?? 0)}',
              style: context.pAppStyle.labelMed14textPrimary,
            )
          ],
        ),
        const SizedBox(
          height: Grid.l,
        ),
        Column(
          children: [
            PValueTextfieldWidget(
              focusNode: _orderFocus,
              controller: _orderUnitTC,
              title: L10n.tr('adet'),
              subTitle: selectedPaymentType.$2 == 0
                  ? PBlocBuilder<IpoBloc, IpoState>(
                      bloc: _ipoBloc,
                      builder: (context, state) {
                        double tradeLimit = 0.0;

                        if (state.ipoTradeLimitModel != null) {
                          tradeLimit = state.ipoTradeLimitModel?.tradeLimit ?? 0;
                        }

                        return Shimmerize(
                          enabled: state.isLoading,
                          child: Text(
                            '${L10n.tr('alinabilir_adet')}: ${MoneyUtils().readableMoney(
                              // (
                              (tradeLimit / (widget.myDemandedIpo.offerPrice ?? 1)).floor()

                              /// (Daha önce girilen adet ekleniyor.) Alınabilir adet kısmı netleştikten sonra burası açılacak yada silinecek.
                              //  +    (widget.myDemandedIpo.unitsDemanded ?? 0))
                              //   .floor()
                              ,
                              pattern: '#,##0',
                            )}',
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                        );
                      })
                  : const SizedBox.shrink(),
              onChanged: (deger) {
                setState(() {
                  _orderUnitTC.text = deger.toString();

                  _amount = MoneyUtils().fromReadableMoney(deger) * (widget.myDemandedIpo.offerPrice ?? 0);
                });
              },
              onSubmitted: (value) {
                setState(() {
                  _orderUnitTC.text = value;

                  if (selectedPaymentType.$2 != 0) {
                    _goBlockagePage(
                      selectedPaymentType,
                    );
                  }

                  FocusScope.of(context).unfocus();
                });
              },
            ),
            const SizedBox(
              height: Grid.m,
            ),

            /// Tutar gosterilen alan yetersiz limitte hata verir
            ConsistentEquivalence(
              title: L10n.tr('estimated_amount'),
              titleValue: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(_amount)}',
            ),
            const SizedBox(
              height: Grid.m,
            ),
            // Ödeme Tipi Nakit Değilse
            if (selectedPaymentType.$2 != 0) ...[
              _orderHasFocus
                  ? _getBlockageButton(
                      context,
                      selectedPaymentType,
                    )
                  : InkWell(
                      onTap: () => _goBlockagePage(
                        selectedPaymentType,
                      ),
                      child: _getBlockageButton(
                        context,
                        selectedPaymentType,
                      ),
                    ),
              const SizedBox(
                height: Grid.m + Grid.xs,
              ),
            ],
            OrderApprovementButtons(
              cancelButtonText: L10n.tr('vazgeç'),
              onPressedCancel: () => router.maybePop(),
              approveButtonText: L10n.tr('onayla'),
              onPressedApprove: () async {
                if (_orderUnitTC.text.isEmpty || MoneyUtils().fromReadableMoney(_orderUnitTC.text) == 0) {
                  return PBottomSheet.show(
                    context,
                    titleWidget: _bottomSheetTitleWidget(selectedPaymentType.$1),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: Grid.m,
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              ImagesPath.alert_circle,
                              width: 52,
                              height: 52,
                              colorFilter: ColorFilter.mode(
                                context.pColorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                              height: Grid.s,
                            ),
                            Text(
                              L10n.tr('please_enter_unit'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // selectedPaymentType.$2 != 0 Ödeme Tipi Nakit Değilse
                if (selectedPaymentType.$2 != 0 && _itemsToBlock == null) {
                  return PBottomSheet.show(
                    context,
                    titleWidget: _bottomSheetTitleWidget(selectedPaymentType.$1),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: Grid.m,
                        ),
                        child: Column(
                          spacing: Grid.s,
                          children: [
                            SvgPicture.asset(
                              ImagesPath.alert_circle,
                              width: 52,
                              height: 52,
                              colorFilter: ColorFilter.mode(
                                context.pColorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              L10n.tr('please_update_blockage'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                _ipoBloc.add(
                  DemandUpdateEvent(
                    customerId: widget.myDemandedIpo.accountExtId!.split('-')[0],
                    accountId: widget.myDemandedIpo.accountExtId!.split('-')[1],
                    functionName: 1,
                    demandDate: DateTime.now().formatToJson(),
                    ipoId: widget.myDemandedIpo.ipoId!,
                    demandId: widget.myDemandedIpo.ipoDemandId!,
                    unitsDemanded: double.parse(_orderUnitTC.text.replaceAll(',', '')),
                    offerPrice: widget.myDemandedIpo.offerPrice ?? 0,
                    checkLimit: true,
                    demandGatheringType: 'M',
                    demandType: 'DEFINITE',
                    paymentTypeId: selectedPaymentType.$2,
                    itemsToBlock: _itemsToBlock,
                    callback: () async {
                      _ipoBloc.add(
                        GetActiveListEvent(
                          pageNumber: 0,
                        ),
                      );

                      router.push(
                        InfoRoute(
                          variant: InfoVariant.success,
                          message: L10n.tr('ipo.demand.order_update_success'),
                        ),
                      );

                      await router.maybePop();
                      await router.maybePop();
                      await router.maybePop();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Row _getBlockageButton(BuildContext context, (String, int) selectedPaymentType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          L10n.tr('payment_type'),
          style: context.pAppStyle.labelMed14textPrimary,
        ),
        Row(
          spacing: Grid.xs,
          children: [
            Text(
              selectedPaymentType.$1,
              style: context.pAppStyle.labelMed14primary,
            ),
            SvgPicture.asset(
              ImagesPath.chevron_right,
              width: 14,
              height: 14,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ],
    );
  }

  (String, int) _paymentType(key) {
    // 0(Nakit) , 5(Fon Blokajlı), 4(Döviz Blokajlı), 10(Bist Hisse Blokajlı)
    switch (key) {
      case 'Cash':
      case 'Nakit':
        return (L10n.tr('ipo_cash'), 0);
      case 'Döviz Blokajı':
        return (L10n.tr('ipo_foreign_exchange_blockage'), 4);
      case 'Fon Blokajı':
      case 'Fund Blockage':
        return (L10n.tr('ipo_fund_blockage'), 5);
      case 'Hisse Blokajı':
      case 'Equity Blockage':
        return (L10n.tr('ipo_equity_blockage'), 10);
      default:
        return (L10n.tr('ipo_cash'), 0);
    }
  }

  Widget _bottomSheetTitleWidget(String selectedPaymentType) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => router.maybePop(),
            child: SvgPicture.asset(
              ImagesPath.chevron_left,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            selectedPaymentType,
            style: context.pAppStyle.labelMed14textPrimary,
          ),
        ),
      ],
    );
  }

  _goBlockagePage(
    (String, int) selectedPaymentType,
  ) {
    if (MoneyUtils().fromReadableMoney(_orderUnitTC.text) == 0 || _orderUnitTC.text.isEmpty) {
      return PBottomSheet.show(
        context,
        titleWidget: _bottomSheetTitleWidget(selectedPaymentType.$1),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            spacing: Grid.s,
            children: [
              SvgPicture.asset(
                ImagesPath.alert_circle,
                width: 52,
                height: 52,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              Text(
                L10n.tr('please_enter_unit'),
              ),
              const SizedBox(
                height: Grid.m,
              ),
            ],
          ),
        ),
      );
    }

    _ipoBloc.add(
      GetBlockageEvent(
        customerId: widget.myDemandedIpo.accountExtId!.split('-')[0],
        accountId: widget.myDemandedIpo.accountExtId!.split('-')[1],
        ipoId: widget.myDemandedIpo.ipoId ?? '',
        paymentType: selectedPaymentType.$2, // 0(Nakit), 5(Fon Blokajlı), 4(Döviz Blokajlı), 10(Bist Hisse Blokajlı)
        isEmpty: (isEmpty) async {
          if (isEmpty) {
            return PBottomSheet.showError(
              context,
              content: selectedPaymentType.$2 == 5
                  ? L10n.tr('ipo_blockage_list_empty_alert_for_fund')
                  : selectedPaymentType.$2 == 4
                      ? L10n.tr('ipo_blockage_list_empty_alert_for_currency')
                      : L10n.tr('ipo_blockage_list_empty_alert_for_bist_equity'), // Hisse Blokajı için
            );
          } else {
            IpoAddDataModel addDataModel = IpoAddDataModel(
              customerId: widget.myDemandedIpo.accountExtId!.split('-')[0],
              accountId: widget.myDemandedIpo.accountExtId!.split('-')[1],
              functionName: 0, // 0(Add)
              demandDate: DateTime.now().formatToJson(),
              ipoId: widget.myDemandedIpo.ipoId ?? '',
              unitsDemanded: MoneyUtils().fromReadableMoney(_orderUnitTC.text).toInt(),
              paymentType:
                  selectedPaymentType.$2, // 0(Nakit), 5(Fon Blokajlı), 4(Döviz Blokajlı), 10(Bist Hisse Blokajlı)
              transactionType: '',
              investorTypeId: UserModel.instance.innerType == 'CONTACT' ? '0000-000002-INT' : '0000-000003-INT',
              demandGatheringType: 'M',
              totalAmount: 0,
              offerPrice: 0,
              minUnits: 0,
              customFields: IpoConstant().ipoKktcCitizenDropdownList[0]['customFields'],
              symbol: widget.myDemandedIpo.name ?? '',
              demandedUnit: MoneyUtils().fromReadableMoney(_orderUnitTC.text).toInt(),
            );

            return PBottomSheet.show(
              context,
              titleWidget: _bottomSheetTitleWidget(selectedPaymentType.$1),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                ),
                child: StatefulBuilder(builder: (context, setstate) {
                  return IpoBlockageListBottomSheet(
                    deputyName: '',
                    ipoId: widget.myDemandedIpo.ipoId ?? '',
                    paymentTypeName: selectedPaymentType.$1,
                    paymentTypeId: selectedPaymentType.$2,
                    ipoPrice: _amount,
                    selectedAccount: widget.myDemandedIpo.accountExtId!,
                    addData: addDataModel,
                    fromUpdatePage: true,
                    demandedAmount: widget.myDemandedIpo.amountDemanded,
                    onChangedAddData: (addData) {
                      setState(() {
                        _itemsToBlock = addData.itemsToBlock;
                      });
                    },
                  );
                }),
              ),
            );
          }
        },
      ),
    );
  }
}

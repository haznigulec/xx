import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/create_order/model/condition.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/order_validator.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/price_selector.dart';
import 'package:piapiri_v2/core/model/condition_enum.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

class PConditionTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final OrderActionTypeEnum action;
  final Function(double newPrice) onPriceChanged;
  final Function(ConditionEnum newPrice) onConditionChanged;
  final MarketListModel? marketListModel;
  final Condition condition;
  final String? title;
  final Function()? onTapPrice;
  const PConditionTextfield({
    super.key,
    this.controller,
    this.focusNode,
    required this.action,
    required this.onPriceChanged,
    required this.onConditionChanged,
    required this.marketListModel,
    required this.condition,
    this.title,
    this.onTapPrice,
  });

  @override
  State<PConditionTextfield> createState() => _PConditionTextfieldState();
}

class _PConditionTextfieldState extends State<PConditionTextfield> {
  late TextEditingController _priceController;
  late FocusNode _focusNode;
  double _limitDown = 0;
  double _limitUp = 0;

  @override
  void initState() {
    super.initState();
    _priceController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    double priceStep = 0.1;
    String symbolType = widget.marketListModel!.type;
    String marketCode = widget.marketListModel!.marketCode;
    double price = 0;
    if (widget.marketListModel == null) return const PLoading();
    if (stringToSymbolType(symbolType) != SymbolTypes.warrant) {
      if (MoneyUtils().fromReadableMoney(_priceController.text) > widget.marketListModel!.limitUp) {
        priceStep = Utils().getPriceStep(
          _limitUp,
          symbolType,
          marketCode,
          widget.marketListModel!.subMarketCode,
          widget.marketListModel!.priceStep,
        );
      } else if (MoneyUtils().fromReadableMoney(_priceController.text) < widget.marketListModel!.limitDown) {
        priceStep = Utils().getPriceStep(
          _limitDown,
          symbolType,
          marketCode,
          widget.marketListModel!.subMarketCode,
          widget.marketListModel!.priceStep,
        );
      } else {
        priceStep = Utils().getPriceStep(
          MoneyUtils().fromReadableMoney(_priceController.text),
          symbolType,
          marketCode,
          widget.marketListModel!.subMarketCode,
          widget.marketListModel!.priceStep,
        );
      }

      if (widget.marketListModel?.limitDown != null && widget.marketListModel?.limitDown != 0) {
        _limitDown =
            MoneyUtils().roundPrice(price: widget.marketListModel!.limitDown, priceStep: priceStep, roundFloor: false);
      }
      if (widget.marketListModel?.limitUp != null && widget.marketListModel?.limitUp != 0) {
        _limitUp =
            MoneyUtils().roundPrice(price: widget.marketListModel!.limitUp, priceStep: priceStep, roundFloor: true);
      }
      double newPrice =
          widget.action == OrderActionTypeEnum.buy ? widget.marketListModel!.ask : widget.marketListModel!.bid;

      price = newPrice == 0 ? widget.marketListModel!.basePrice : newPrice;
    }

    return PValueTextfieldWidget(
      controller: _priceController,
      title: widget.title ?? L10n.tr('fiyat'),
      focusNode: _focusNode,
      backgroundColor: context.pColorScheme.card,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      inputFormatters: [
        AppInputFormatters.decimalFormatter(
          maxDigitAfterSeparator: 2,
        ),
      ],

      onTapPrice: () => widget.onTapPrice?.call(),
      subTitle: InkWell(
        splashColor: context.pColorScheme.transparent,
        highlightColor: context.pColorScheme.transparent,
        child: InkWell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                L10n.tr(widget.condition.condition.localizationKey),
                style: context.pAppStyle.labelReg14textSecondary,
              ),
              const SizedBox(
                width: Grid.xxs,
              ),
              SvgPicture.asset(
                ImagesPath.chevron_list,
                height: 15,
                width: 15,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.textSecondary,
                  BlendMode.srcIn,
                ),
              )
            ],
          ),
          onTap: () {
            PBottomSheet.show(
              context,
              title: L10n.tr('fiyat_kosul'),
              titlePadding: const EdgeInsets.only(
                top: Grid.m,
              ),
              child: ListView.separated(
                itemCount: ConditionEnum.values.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BottomsheetSelectTile(
                    title: L10n.tr(ConditionEnum.values[index].localizationKey),
                    value: ConditionEnum.values[index],
                    isSelected: widget.condition.condition == ConditionEnum.values[index],
                    onTap: (_, value) => widget.onConditionChanged(value),
                  );
                },
                separatorBuilder: (context, index) => const PDivider(),
              ),
            );
          },
        ),
      ),
      prefixText: CurrencyEnum.turkishLira.symbol,
      prefix: widget.marketListModel == null || stringToSymbolType(symbolType) == SymbolTypes.warrant
          ? null
          : GestureDetector(
              child: SvgPicture.asset(
                height: 17,
                width: 17,
                ImagesPath.sort_up_down,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              onTap: () {
                _showPriceSteps(
                  price,
                  priceStep,
                  _limitUp,
                  _limitDown,
                  symbolType,
                  marketCode,
                );
              },
            ),
      onFocusChange: (hasFocus) async {
        if (!hasFocus) {
          double price = _priceController.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_priceController.text);
          price = OrderValidator.priceValidator(
            context,
            symbolName: widget.marketListModel!.symbolCode,
            price: price,
            limitUp: _limitUp,
            limitDown: _limitDown,
            type: stringToSymbolType(symbolType),
          );
          _priceController.text = MoneyUtils().readableMoney(price);
          widget.onPriceChanged(price);
        }
      },
    );
  }

  void _showPriceSteps(
      double price, double priceStep, double limitUp, double limitDown, String symbolType, String marketCode) {
    List<double> priceSteps = MoneyUtils().getPriceSteps(
      price: price,
      priceStep: priceStep,
      limitUp: limitUp,
      limitDown: limitDown,
      symbolType: symbolType,
      marketCode: marketCode,
    );
    PBottomSheet.show(context,
        title: L10n.tr('fiyat'),
        child: PriceSelector(
          priceSteps: priceSteps,
          currentPrice: MoneyUtils().fromReadableMoney(_priceController.text),
          onPriceChanged: (newPrice) {
            if (newPrice > limitUp) {
              newPrice = limitUp;
            } else if (newPrice < limitDown) {
              newPrice = limitDown;
            }
            _priceController.text = MoneyUtils().readableMoney(newPrice);

            widget.onPriceChanged(newPrice);
          },
        ));
  }
}

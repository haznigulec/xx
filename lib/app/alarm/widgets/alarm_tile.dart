import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_bloc.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_event.dart';
import 'package:piapiri_v2/app/alarm/widgets/price_alarm_last_price_widget.dart';
import 'package:piapiri_v2/app/data_grid/widgets/slide_option.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/alarm_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AlarmTile extends StatelessWidget {
  final BaseAlarm alarm;
  final bool isPriceAlarm;
  final bool showCurrentPrice;
  final double horizontalPadding;

  const AlarmTile({
    super.key,
    required this.alarm,
    this.isPriceAlarm = false,
    this.showCurrentPrice = true,
    this.horizontalPadding = Grid.m,
  });

  @override
  Widget build(BuildContext context) {
    BaseAlarm currentAlarm = isPriceAlarm ? alarm as PriceAlarm : alarm as NewsAlarm;
    return Slidable(
      key: ValueKey<String>(alarm.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.32,
        children: [
          const Spacer(),
          LayoutBuilder(
            builder: (context, constraints) => SlideOptions(
              height: constraints.maxHeight,
              imagePath: ImagesPath.trash,
              backgroundColor: context.pColorScheme.critical,
              iconColor: context.pColorScheme.lightHigh,
              onTap: () => _showDeleteAlert(context), // Kullanıcıya Silme alertini gösterdiğimiz yer.,
            ),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: Grid.m,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tileWidget(currentAlarm, context),
            if (currentAlarm.note.isNotEmpty) ...[
              const SizedBox(
                height: Grid.s,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    ImagesPath.message,
                    width: 15,
                    height: 15,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    width: Grid.xs,
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - Grid.m * 2 - 19,
                    child: Text(
                      currentAlarm.note,
                      style: context.pAppStyle.labelReg12textPrimary,
                    ),
                  )
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tileWidget(BaseAlarm currentAlarm, BuildContext context) {
    final symbolType = stringToSymbolType(currentAlarm.symbolType);
    final currencySymbol = symbolType == SymbolTypes.parity ? '' : CurrencyEnum.turkishLira.symbol;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _leadingSymbolWidget(
          currentAlarm,
          context,
        ),
        if (alarm is PriceAlarm) ...[
          PriceAlarmLastPriceWidget(
            symbol: alarm.symbol,
            currencySymbol: currencySymbol,
          ),
          Text(
            '$currencySymbol${MoneyUtils().readableMoney((alarm as PriceAlarm).price)}',
            textAlign: TextAlign.end,
            style: context.pAppStyle.labelMed14textPrimary,
          ),
        ]
      ],
    );
  }

  Widget _leadingSymbolWidget(BaseAlarm currentAlarm, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SymbolIcon(
          symbolName: stringToSymbolType(currentAlarm.symbolType) == SymbolTypes.option ||
                  stringToSymbolType(currentAlarm.symbolType) == SymbolTypes.future ||
                  stringToSymbolType(currentAlarm.symbolType) == SymbolTypes.warrant
              ? currentAlarm.underlyingName
              : alarm.symbol,
          symbolType: stringToSymbolType(currentAlarm.symbolType),
          size: 28,
        ),
        const SizedBox(
          width: Grid.s,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alarm.symbol,
              style: context.pAppStyle.labelReg14textPrimary,
            ),
            if (currentAlarm.description.isNotEmpty)
              SizedBox(
                width: MediaQuery.of(context).size.width * .5 - 20,
                child: isPriceAlarm
                    ? Text(
                        currentAlarm.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.pAppStyle.labelMed12textSecondary,
                      )
                    : Text.rich(
                        TextSpan(
                          text: currentAlarm.description,
                          style: context.pAppStyle.labelMed12textSecondary,
                          children: [
                            WidgetSpan(
                              child: Baseline(
                                baselineType: TextBaseline.alphabetic,
                                baseline: -5, // Text'i ortalaması için verilen değer
                                child: Text(
                                  ' • ',
                                  style: context.pAppStyle.labelReg14textSecondary.copyWith(
                                    fontSize: Grid.s + Grid.xxs,
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: L10n.tr(stringToSymbolType(currentAlarm.symbolType).filter?.localization ?? ''),
                              style: context.pAppStyle.labelMed12textSecondary,
                            ),
                          ],
                        ),
                      ),
              ),
          ],
        ),
      ],
    );
  }

  void _showDeleteAlert(BuildContext context) {
    PBottomSheet.showError(
      context,
      content: '',
      contentWidget: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: alarm.symbol,
              style: context.pAppStyle.labelMed16textPrimary,
            ),
            TextSpan(
              text: L10n.tr(
                isPriceAlarm ? 'delete_price_alarm_warning' : 'delete_alarm_warning',
                namedArgs: {
                  '': '',
                },
              ),
              style: context.pAppStyle.labelReg16textPrimary,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      showFilledButton: true,
      showOutlinedButton: true,
      filledButtonText: L10n.tr('onayla'),
      outlinedButtonText: L10n.tr('vazgec'),
      onFilledButtonPressed: () async {
        getIt<AlarmBloc>().add(
          RemoveAlarmEvent(
            id: alarm.id,
            callback: () {
              getIt<AlarmBloc>().add(
                GetAlarmsEvent(),
              );
            },
          ),
        );
        await router.maybePop();
      },
      onOutlinedButtonPressed: () {
        router.maybePop();
      },
    );
  }
}

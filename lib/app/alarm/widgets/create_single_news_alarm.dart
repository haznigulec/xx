import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_bloc.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_event.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_state.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/alarm_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CreateSingleNewsAlarm extends StatefulWidget {
  final SymbolModel symbol;
  const CreateSingleNewsAlarm({
    super.key,
    required this.symbol,
  });

  @override
  State<CreateSingleNewsAlarm> createState() => _CreateSingleNewsAlarmState();
}

/// Sembol Detaydan da Anasayfadan da gidince alarm kurulurken artık kullanıcıya tek seferde
/// hem Fiyat hem Haber alarmı kurduruyoruz burası Haber Alarmı sayfası
/// Sadece ilgili sembol ile ilgili haber alarmı bilgisini gösteriyoruz.
class _CreateSingleNewsAlarmState extends State<CreateSingleNewsAlarm> {
  late final AlarmBloc _alarmBloc;

  @override
  void initState() {
    _alarmBloc = getIt<AlarmBloc>();
    _alarmBloc.add(
      GetAlarmsEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        Grid.m,
      ),
      child: Column(
        children: [
          PBlocBuilder<AlarmBloc, AlarmState>(
            bloc: _alarmBloc,
            builder: (context, state) {
              // Haber alarmının olup olmadığını kontrol ediyoruz
              bool isExist = state.newsAlarms.any((e) => e.symbol == widget.symbol.name);

              return Row(
                children: [
                  SymbolIcon(
                    symbolName: stringToSymbolType(widget.symbol.typeCode) == SymbolTypes.option ||
                            stringToSymbolType(widget.symbol.typeCode) == SymbolTypes.future ||
                            stringToSymbolType(widget.symbol.typeCode) == SymbolTypes.warrant
                        ? widget.symbol.underlyingName
                        : widget.symbol.name,
                    symbolType: stringToSymbolType(widget.symbol.typeCode),
                    size: 28,
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.symbol.name,
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                        Text(
                          widget.symbol.description,
                          style: context.pAppStyle.labelMed12textSecondary,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    splashColor: context.pColorScheme.transparent,
                    highlightColor: context.pColorScheme.transparent,
                    onTap: () {
                      if (isExist) {
                        // Haber alarmı kurulu ise kaldırıyoruz
                        List<NewsAlarm> deleteNewAlarmList =
                            state.newsAlarms.where((e) => e.symbol == widget.symbol.name).toList();

                        _alarmBloc.add(
                          RemoveAlarmEvent(
                            id: deleteNewAlarmList[0].id,
                            callback: () {
                              _alarmBloc.add(
                                GetAlarmsEvent(),
                              );
                            },
                          ),
                        );

                        return;
                      } else {
                        if (_alarmBloc.state.priceAlarms.length + _alarmBloc.state.newsAlarms.length >= 90) {
                          PBottomSheet.showError(
                            context,
                            content: L10n.tr('max_alarm_limit_reached'),
                          );
                          return;
                        }
                        // Haber alarmı kuruyoruz
                        _alarmBloc.add(
                          SetNewsAlarmEvent(
                            symbolName: widget.symbol.name,
                          ),
                        );

                        return;
                      }
                    },
                    child: Row(
                      spacing: Grid.xxs,
                      children: [
                        Text(
                          L10n.tr(isExist ? 'open' : 'closed'),
                          style: context.pAppStyle.interRegularBase.copyWith(
                            fontSize: Grid.m - Grid.xxs,
                            color: isExist ? context.pColorScheme.primary : context.pColorScheme.textSecondary,
                          ),
                        ),
                        SvgPicture.asset(
                          ImagesPath.chevron_list,
                          width: Grid.s + Grid.xs,
                          colorFilter: ColorFilter.mode(
                            isExist ? context.pColorScheme.primary : context.pColorScheme.textSecondary,
                            BlendMode.srcIn,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

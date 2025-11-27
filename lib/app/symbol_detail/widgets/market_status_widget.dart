import 'dart:async';

import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/bloc/time/time_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/session_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class MarketStatusWidget extends StatefulWidget {
  final MarketListModel symbol;
  final SymbolTypes type;

  const MarketStatusWidget({
    super.key,
    required this.symbol,
    required this.type,
  });

  @override
  State<MarketStatusWidget> createState() => _MarketStatusWidgetState();
}

class _MarketStatusWidgetState extends State<MarketStatusWidget> {
  final TimeBloc _timeBloc = getIt<TimeBloc>();
  final AppInfoBloc _appInfoBloc = getIt<AppInfoBloc>();
  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  SessionModel? _sessionModel;
  bool? _isSessionOpen;
  DateTime? _earliestSessionDate;

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  initState() {
    String exchangeCode = widget.symbol.exchangeCode;
    String subMarketCode = widget.symbol.subMarketCode;
    // verilen symbol e gore sessionModel cekilir
    _sessionModel = exchangeCode == 'BISTPP'
        ? _appInfoBloc.state.bistPPSession
        : exchangeCode == 'BISTVIOP'
            ? _appInfoBloc.state.bistViopSession.firstWhereOrNull((element) => element.marketCode == subMarketCode)
            : null;
    // TimeBloc'a TimeConnectEvent gönderilir
    _timeBloc.add(
      TimeConnectEvent(),
    );
    // TimeBloc'un state'indeki mxTime'dan DateTime nesnesi oluşturulur
    getCurrentTime();
    // Session açık mı kapalı mı kontrol edilir
    _isSessionOpen = isSessionOpen();
    if (_sessionModel != null && _isSessionOpen == false) {
      // Session açık değilse en erken session tarihi alınır
      _earliestSessionDate = getEarliestSessionDate();
    }
    //Dakikada bir alinacak sekilde timer baslatilir
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_timeBloc.state.mxTime == null) return;
      getCurrentTime();
      _isSessionOpen = isSessionOpen();
      if (_isSessionOpen != null && _isSessionOpen == false) {
        _earliestSessionDate = getEarliestSessionDate();
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    // Sayfa kapandığında Timer'ı durdur
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Eğer symbol BISTVIOP veya BISTPP değilse veya sessionModel null ise bos don
    if ((widget.symbol.exchangeCode != 'BISTVIOP' && widget.symbol.exchangeCode != 'BISTPP') ||
        _isSessionOpen == null) {
      return const SizedBox();
    }

    return _isSessionOpen!
        ? Row(
            children: [
              SvgPicture.asset(
                ImagesPath.sun,
                width: 15,
                height: 15,
              ),
              const SizedBox(width: Grid.xs),
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: context.pAppStyle.labelReg12textSecondary,
                    children: [
                      TextSpan(
                        text: L10n.tr(
                          'market_session_open',
                        ),
                      ),
                      TextSpan(
                        text: ' • ',
                        style: context.pAppStyle.labelMed14textSecondary,
                      ),
                      TextSpan(
                        text: L10n.tr(
                          'market_session_open_trade',
                          args: [
                            _capitalizeFirst(
                              widget.type == SymbolTypes.future
                                  ? L10n.tr('viop')
                                  : widget.type == SymbolTypes.warrant
                                      ? L10n.tr('warrant')
                                      : L10n.tr('hisse'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Row(
            children: [
              SvgPicture.asset(
                ImagesPath.moon,
                width: 15,
                height: 15,
              ),
              const SizedBox(width: Grid.xs),
              if (_sessionModel != null)
                Expanded(
                  child: Text(
                    L10n.tr(
                      'market_will_be_opened',
                      args: [
                        DateTimeUtils.dateFormat(
                          _earliestSessionDate ??
                              DateTime.now().add(
                                const Duration(days: 1),
                              ),
                        ),
                        _sessionModel!.openHour,
                      ],
                    ),
                    style: context.pAppStyle.labelReg12textSecondary,
                  ),
                ),
            ],
          );
  }

  // TimeBloc'un state'indeki mxTime'dan DateTime nesnesi oluşturulur
  void getCurrentTime() {
    if (_timeBloc.state.mxTime != null) {
      DateTime mxtime = DateTime.fromMicrosecondsSinceEpoch(_timeBloc.state.mxTime!.timestamp.toInt());
      _currentTime = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, mxtime.hour, mxtime.minute, mxtime.second);
    } else {
      _currentTime = DateTime.now();
    }
  }

  bool? isSessionOpen() {
    // Eğer tarih haftasonu veya tatil ise false döner
    if (DateTimeUtils().isWeekend(date: _currentTime)) return false;
    if (DateTimeUtils().isHoliday(date: _currentTime)) return false;

    if (_sessionModel == null) return null;
    // Şu anki tarih ile saatleri birleştirerek DateTime nesneleri oluştur
    DateTime startTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day,
        int.parse(_sessionModel!.openHour.split(":")[0]), int.parse(_sessionModel!.openHour.split(":")[1]));

    DateTime endTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day,
        int.parse(_sessionModel!.closeHour.split(":")[0]), int.parse(_sessionModel!.closeHour.split(":")[1]));

    return _currentTime.isAfter(startTime) && _currentTime.isBefore(endTime);
  }

  // Eğer session açık değilse en erken session tarihini al
  DateTime getEarliestSessionDate() {
    DateTime startTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day,
        int.parse(_sessionModel!.openHour.split(":")[0]), int.parse(_sessionModel!.openHour.split(":")[1]));
    DateTime currentTime = _currentTime;
    if (currentTime.isAfter(startTime)) {
      currentTime = currentTime.add(const Duration(days: 1));
    }
    currentTime = DateTimeUtils.moveDateToWeekday(currentTime);
    String earliestDate = DateTimeUtils.serverDate(currentTime);
    int indexOfHoliday = getIt<AppInfoBloc>().state.holidays.indexWhere((element) => element == earliestDate);
    if (indexOfHoliday != -1) {
      while (indexOfHoliday != -1) {
        currentTime = currentTime.add(const Duration(days: 1));
        currentTime = DateTimeUtils.moveDateToWeekday(currentTime);
        earliestDate = DateTimeUtils.serverDate(currentTime);
        indexOfHoliday = getIt<AppInfoBloc>().state.holidays.indexWhere((element) => element == earliestDate);
      }
    }
    return currentTime;
  }
}

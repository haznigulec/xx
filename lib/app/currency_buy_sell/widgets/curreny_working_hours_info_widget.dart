import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CurrencyWorkingHoursInfoWidget extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  const CurrencyWorkingHoursInfoWidget({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    String infoText = L10n.tr(
      'currency_transaction_working_hour_info',
      args: [
        startDate.formatTimeHourMinute(),
        endDate.formatTimeHourMinute(),
      ],
    );

    DateTime now = DateTime.fromMicrosecondsSinceEpoch(
      getIt<TimeBloc>().state.mxTime?.timestamp != null
          ? getIt<TimeBloc>().state.mxTime!.timestamp.toInt()
          : DateTime.now().microsecondsSinceEpoch,
    );

    if (now.hour < startDate.hour || now.hour >= endDate.hour) {
      infoText = infoText + L10n.tr('currency_transcation_specified_time_info');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: Grid.s + Grid.xxs,
      children: [
        PInfoWidget(
          infoText: infoText,
        ),
        PInfoWidget(
          infoText: L10n.tr('currency_legal_info'),
        ),
      ],
    );
  }
}

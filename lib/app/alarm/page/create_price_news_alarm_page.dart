import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/alarm/page/create_price_alarm_page.dart';
import 'package:piapiri_v2/app/alarm/widgets/create_single_news_alarm.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class CreatePriceNewsAlarmPage extends StatelessWidget {
  final SymbolModel symbol;
  const CreatePriceNewsAlarmPage({
    super.key,
    required this.symbol,
  });

  /// Sembol Detaydan da Anasayfadan da gidince alarm kurulurken artık kullanıcıya tek seferde
  /// hem Fiyat hem Haber alarmı kurduruyoruz
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PInnerAppBar(
        title: '${symbol.name} ${L10n.tr('alarm')}',
      ),
      body: PMainTabController(
        tabs: [
          PTabItem(
            title: L10n.tr('fiyat_alarmi'),
            page: CreatePriceAlarmPage(
              symbol: symbol,
            ),
          ),
          PTabItem(
            title: L10n.tr('haber_alarmi'),
            page: CreateSingleNewsAlarm(
              symbol: symbol,
            ),
          ),
        ],
      ),
    );
  }
}

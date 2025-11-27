import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/cashflow_transaction_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

//Amerikan borsaları Bakiye İşlem Limiti Widgetı
class UsSelectAccountWidget extends StatefulWidget {
  final Function(double) onAmount;
  const UsSelectAccountWidget({
    super.key,
    required this.onAmount,
  });

  @override
  State<UsSelectAccountWidget> createState() => _UsSelectAccountWidgetState();
}

class _UsSelectAccountWidgetState extends State<UsSelectAccountWidget> {
  late AssetsBloc _assetsBloc;

  @override
  void initState() {
    _assetsBloc = getIt<AssetsBloc>();
    _assetsBloc.add(GetCapraCollateralInfoEvent((double amount) {
      setState(() {
        widget.onAmount(amount);
      });
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AssetsBloc, AssetsState>(
      bloc: _assetsBloc,
      builder: (context, assetsState) {
        if (assetsState.isLoading) {
          return const PLoading();
        }
        if (assetsState.capraCollateralInfo?.buyingPower == null) {
          widget.onAmount(assetsState.capraCollateralInfo?.buyingPower ?? 0);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CashflowTransactionWidget(
              isUs: true,
              limitText: L10n.tr('us_trade_limit'),
              limitValue: assetsState.capraCollateralInfo?.buyingPower ?? 0,
            ),
          ],
        );
      },
    );
  }
}

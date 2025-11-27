import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/depth/pages/realized_transactions_page.dart';
import 'package:piapiri_v2/app/depth/widgets/depth_no_license.dart';
import 'package:piapiri_v2/app/depth/pages/depth_page.dart';
import 'package:piapiri_v2/app/license/bloc/license_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class DepthTab extends StatelessWidget {
  final MarketListModel symbol;
  const DepthTab({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    SymbolTypes symbolType = stringToSymbolType(symbol.type);
    if ((symbolType == SymbolTypes.future || symbolType == SymbolTypes.option) &&
        !getIt<LicenseBloc>().state.isViopDepthEnabled) {
      return const DepthNoLicense();
    }
    if ((symbolType == SymbolTypes.equity || symbolType == SymbolTypes.warrant) &&
        !getIt<LicenseBloc>().state.isDepthEnabled) {
      return const DepthNoLicense();
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          DepthPage(symbol: symbol),
          const SizedBox(height: Grid.l),
          RealizedTransactionsPage(symbol: symbol),
        ],
      ),
    );
  }
}

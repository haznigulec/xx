import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/booklet/pages/booklet_page.dart';
import 'package:piapiri_v2/app/booklet/widgets/booklet_no_license.dart';
import 'package:piapiri_v2/app/license/bloc/license_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class BookletTab extends StatelessWidget {
  final MarketListModel symbol;
  const BookletTab({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    if (!getIt<LicenseBloc>().state.isBookletEnabled) {
      return const BookletNoLicense();
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          BookletPage(symbol: symbol),
        ],
      ),
    );
  }
}

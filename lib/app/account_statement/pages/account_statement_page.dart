import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/account_statement/pages/domestic_account_statement_page.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class AccountStatementPage extends StatelessWidget {
  const AccountStatementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('account_summary'),
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Expanded(
              child: DomesticAccountStatementPage(),
            )
          ],
        ),
      ),
    );
  }
}

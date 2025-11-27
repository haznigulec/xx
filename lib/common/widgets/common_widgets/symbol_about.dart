import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/list/symbol_about_tile.dart';
import 'package:piapiri_v2/core/model/symbol_info_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolAbout extends StatelessWidget {
  final SymbolInfoModel symbolInfo;
  const SymbolAbout({
    super.key,
    required this.symbolInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .7),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SymbolAboutTile(
              leading: L10n.tr('sirket_adi'),
              trailing: symbolInfo.description ?? '',
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('bist_code'),
              trailing: symbolInfo.code ?? '',
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('kayitli_sermaye'),
              trailing: '₺${MoneyUtils().compactMoney(double.parse(symbolInfo.capital ?? ''))}',
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('merkez_adres'),
              trailing: symbolInfo.address ?? '',
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('web_adres'),
              trailing: symbolInfo.website ?? '',
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('telefon_numarası'),
              trailing: symbolInfo.phone ?? '',
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('fax_numarasi'),
              trailing: symbolInfo.fax ?? '',
              ignoreHeight: true,
            ),
            if (symbolInfo.activityArea != null) ...[
              const PDivider(),
              const SizedBox(
                height: Grid.m,
              ),
              Text(
                L10n.tr('faaliyet_alani'),
                textAlign: TextAlign.start,
                style: context.pAppStyle.labelReg14textSecondary,
              ),
              const SizedBox(
                height: Grid.s + Grid.xs,
              ),
              Text(
                symbolInfo.activityArea ?? '',
                textAlign: TextAlign.start,
                style: context.pAppStyle.labelMed14textPrimary,
              ),
              const SizedBox(
                height: Grid.m,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

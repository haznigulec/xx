import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/agreements/pages/agreements_form_card_tile.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/model/agreements_model.dart';

class AgreementFormCard extends StatelessWidget {
  final AgreementsModel reconcilition;
  final String fullname;
  final String customerExtId;
  const AgreementFormCard({
    super.key,
    required this.reconcilition,
    required this.fullname,
    required this.customerExtId,
  });

  @override
  Widget build(BuildContext context) {
    String date = '';

    if (reconcilition.periodStartDate != null && reconcilition.periodStartDate!.isNotEmpty) {
      date = '$date${DateTimeUtils.dateFormat(
        DateTime.parse(
          reconcilition.periodStartDate ?? DateTime.now().toString(),
        ),
      )} - ';
    }
    if (reconcilition.periodEndDate != null && reconcilition.periodEndDate!.isNotEmpty) {
      date = date +
          DateTimeUtils.dateFormat(
            DateTime.parse(
              reconcilition.periodEndDate ?? DateTime.now().toString(),
            ),
          );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AgreementsFormCardTile(
          leadingText: 'hesap_numarasi',
          trailingText: customerExtId,
        ),
        AgreementsFormCardTile(
          leadingText: 'hesap_adi',
          trailingText: fullname,
        ),
        AgreementsFormCardTile(
          leadingText: 'mutabakat_tarihi',
          trailingText: date,
        ),
      ],
    );
  }
}

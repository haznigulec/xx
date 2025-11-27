import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_type_enum.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TransactionTypeFilterWidget extends StatefulWidget {
  final TransactionHistoryTypeEnum? transactionTypeEnum;
  final Function(TransactionHistoryTypeEnum?) onSelectedType;
  const TransactionTypeFilterWidget({
    super.key,
    required this.transactionTypeEnum,
    required this.onSelectedType,
  });

  @override
  State<TransactionTypeFilterWidget> createState() => _TransactionTypeFilterWidgetState();
}

class _TransactionTypeFilterWidgetState extends State<TransactionTypeFilterWidget> {
  late TransactionHistoryTypeEnum? _selectedType;

  @override
  void initState() {
    _selectedType = widget.transactionTypeEnum;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: TransactionHistoryTypeEnum.values
          .where((element) => element != TransactionHistoryTypeEnum.all)
          .map(
            (e) => InkWell(
              onTap: () {
                if (_selectedType == e) {
                  _selectedType = null;
                  widget.onSelectedType(_selectedType);
                  return;
                }
                setState(() {
                  _selectedType = e;
                  widget.onSelectedType(e);
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Grid.s + Grid.xs,
                ),
                child: Row(
                  spacing: Grid.s,
                  children: [
                    SvgPicture.asset(
                      _selectedType == e ? ImagesPath.selectedCircle : ImagesPath.unselectedCircle,
                      width: 15,
                      height: 15,
                    ),
                    Text(
                      L10n.tr(e.localizationKey),
                      style: context.pAppStyle.labelReg14textPrimary,
                    )
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

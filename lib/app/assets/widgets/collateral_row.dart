import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CollateralRow extends StatelessWidget {
  const CollateralRow({
    super.key,
    required this.name,
    required this.value,
  });
  final String name;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: Grid.s,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              L10n.tr(name),
              maxLines: 2,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).unselectedWidgetColor,
                  ),
            ),
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
          ),
        ],
      ),
    );
  }
}

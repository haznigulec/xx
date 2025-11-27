import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderTypeWidget extends StatefulWidget {
  final OrderTypeEnum orderType;
  final Function(OrderTypeEnum)? onOrderTypeChanged;
  const OrderTypeWidget({
    super.key,
    required this.orderType,
    this.onOrderTypeChanged,
  });

  @override
  State<OrderTypeWidget> createState() => _OrderTypeWidgetState();
}

class _OrderTypeWidgetState extends State<OrderTypeWidget> {
  OrderTypeEnum _selectedOrderType = OrderTypeEnum.market;

  @override
  void initState() {
    _selectedOrderType = widget.orderType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<OrderTypeEnum> orderTypeList =
        OrderTypeEnum.values.where((e) => e == OrderTypeEnum.market || e == OrderTypeEnum.limit).toList();

    return InkWell(
      key: const ValueKey('chain_order_type'),
      onTap: () {
        PBottomSheet.show(
          context,
          title: L10n.tr('emir_tipi'),
          titlePadding: const EdgeInsets.only(
            top: Grid.m,
          ),
          child: ListView.separated(
            itemCount: orderTypeList.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const PDivider(),
            itemBuilder: (context, index) {
              OrderTypeEnum filter = orderTypeList[index];

              return BottomsheetSelectTile(
                title: L10n.tr(
                  filter.localizationKey,
                ),
                subTitle: L10n.tr(
                  filter.descLocalizationKey,
                ),
                value: filter,
                isSelected: _selectedOrderType == filter,
                onTap: (title, value) {
                  setState(() {
                    _selectedOrderType = value;
                    widget.onOrderTypeChanged?.call(_selectedOrderType);
                  });
                  router.maybePop();
                },
              );
            },
          ),
        );
      },
      child: Row(
        children: [
          Text(
            L10n.tr(_selectedOrderType.localizationKey),
            style: context.pAppStyle.labelMed14primary,
          ),
          const SizedBox(
            width: Grid.s,
          ),
          SvgPicture.asset(
            ImagesPath.chevron_down,
            width: 15,
            height: 15,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          )
        ],
      ),
    );
  }
}

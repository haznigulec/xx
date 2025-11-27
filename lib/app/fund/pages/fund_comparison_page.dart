// import 'package:auto_route/auto_route.dart';
// import 'package:piapiri_v2/common/widgets/buttons/button.dart';
// import 'package:design_system/foundations/spacing/grid.dart';
// import 'package:expandable/expandable.dart';
// import 'package:flutter/material.dart';
// import 'package:piapiri_v2/app/fund/model/fund_comparion_enum.dart';
// import 'package:piapiri_v2/common/utils/button_padding.dart';
// import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
// import 'package:piapiri_v2/core/config/router_locator.dart';
// import 'package:piapiri_v2/core/utils/localization_utils.dart';

// @RoutePage()
// class FundComparisonPage extends StatefulWidget {
//   final DateTime startDate;
//   final DateTime endDate;
//   final Function(Map<String, dynamic>) onFiltered;
//   const FundComparisonPage({
//     super.key,
//     required this.startDate,
//     required this.endDate,
//     required this.onFiltered,
//   });

//   @override
//   State<FundComparisonPage> createState() => _FundComparisonPageState();
// }

// class _FundComparisonPageState extends State<FundComparisonPage> {
//   final ExpandableController _expandableController = ExpandableController(
//     initialExpanded: false,
//   );

//   DateTime _startDate = DateTime.now(), _endDate = DateTime.now();

//   @override
//   initState() {
//     _startDate = widget.startDate;
//     _endDate = widget.endDate;
//     super.initState();
//   }

//   @override
//   dispose() {
//     _expandableController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PInnerAppBar(
//         title: L10n.tr('fund_comparison'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(Grid.s),
//         child: Column(
//           children: [
//             // GeneralInfoWidget(infoText: L10n.tr('fund_comparison_info')),
//             // const SizedBox(height: Grid.m),
//             // RowTypeRightArrowWidget(
//             //   title: L10n.tr('by_income'),
//             //   onTap: () {
//             //     setState(() {
//             //       _expandableController.toggle();
//             //     });
//             //   },
//             // ),
//             ExpandablePanel(
//               controller: _expandableController,
//               theme: const ExpandableThemeData(
//                 hasIcon: false,
//                 tapHeaderToExpand: false,
//               ),
//               header: const SizedBox.shrink(),
//               collapsed: const SizedBox.shrink(),
//               expanded: const Padding(
//                 padding: EdgeInsets.only(top: Grid.s),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Expanded(
//                     //   child: DatePickerInput(
//                     //     title: L10n.tr('baslangic'),
//                     //     initialDate: _startDate,
//                     //     maximumDate: DateTime.now(),
//                     //     color: Theme.of(context).cardColor,
//                     //     onChanged: (selectedDate) {
//                     //       setState(() {
//                     //         _startDate = selectedDate;
//                     //       });
//                     //     },
//                     //   ),
//                     // ),
//                     SizedBox(
//                       width: Grid.s,
//                     ),
//                     // Expanded(
//                     //   child: DatePickerInput(
//                     //     title: L10n.tr('bitis'),
//                     //     initialDate: _endDate,
//                     //     maximumDate: DateTime.now(),
//                     //     color: Theme.of(context).cardColor,
//                     //     onChanged: (selectedDate) {
//                     //       setState(() {
//                     //         _endDate = selectedDate;
//                     //       });
//                     //     },
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: Grid.m),
//             // RowTypeRightArrowWidget(
//             //   title: L10n.tr('yonetim_ucretine_gore'),
//             //   onTap: () {
//             //     widget.onFiltered({
//             //       'title': FundComparionEnum.managementFee.value,
//             //     });

//             //     router.maybePop();
//             //   },
//             // ),
//             const SizedBox(height: Grid.m),
//             // RowTypeRightArrowWidget(
//             //   title: L10n.tr('buyukluge_gore'),
//             //   onTap: () {
//             //     widget.onFiltered({
//             //       'title': FundComparionEnum.portfolioSize.value,
//             //     });

//             //     router.maybePop();
//             //   },
//             // ),
//           ],
//         ),
//       ),
//          bottomNavigationBar: !_expandableController.expanded
//           ? const SizedBox.shrink()
//           : generalButtonPadding(
//               context: context,
//               child: PButton(
//                 text: L10n.tr('uygula'),
//                 onPressed: () {
//                   widget.onFiltered({
//                     'title': FundComparionEnum.profit.value,
//                     'startDate': _startDate,
//                     'endDate': _endDate,
//                   });
//                   router.maybePop();
//                 },
//               ),
//             ),
//     );
//   }
// }

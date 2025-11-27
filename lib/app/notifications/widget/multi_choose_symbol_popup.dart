// import 'package:piapiri_v2/common/widgets/buttons/button.dart';
// import 'package:design_system/foundations/spacing/grid.dart';
// import 'package:flutter/material.dart';
// import 'package:piapiri_v2/app/notifications/model/multi_choose_radio_model.dart';
// import 'package:piapiri_v2/core/config/router_locator.dart';

// class MultiChooseSymbolPopup extends StatelessWidget {
//   final List<String> symbolList;
//   final Function(String) selectedSymbol;
//   final String title;

//   const MultiChooseSymbolPopup({
//     super.key,
//     required this.symbolList,
//     required this.selectedSymbol,
//     required this.title,
//   });

//   MultiChooseSymbolPopup.showQuickOrder(
//     BuildContext context, {
//     this.symbolList = const [],
//     required this.selectedSymbol,
//     required this.title,
//   }) {
//     String _selectedSymbol = '';
//     WoltModalSheet.show<void>(
//       maxPageHeight: .9,
//       context: context,
//       pageListBuilder: (modalSheetContext) {
//         return [
//           WoltModalSheetPage.withSingleChild(
//             hasSabGradient: false,
//             isTopBarLayerAlwaysVisible: true,
//             topBarTitle: Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             stickyActionBar: BzButton(
//               text: Utils.tr('devam'),
//               onPressed: () {
//                 router.maybePop();
//                 if (_selectedSymbol.isEmpty) {
//                   return PPDialogs.basicAlertDialog(Utils.tr('sembol_seciniz'), AlertIconEnum.warning);
//                 }
//                 selectedSymbol(_selectedSymbol);
//               },
//               color: Theme.of(context).focusColor,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: Grid.xxl),
//               child: SymbolListWidget(
//                 symbolList: symbolList,
//                 selectedSymbol: (selectedSymbol) {
//                   _selectedSymbol = selectedSymbol;
//                 },
//               ),
//             ),
//           ),
//         ];
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox.shrink();
//   }
// }

// class SymbolListWidget extends StatefulWidget {
//   final List<String> symbolList;
//   final Function(String) selectedSymbol;
//   const SymbolListWidget({super.key, required this.symbolList, required this.selectedSymbol});

//   @override
//   State<SymbolListWidget> createState() => _SymbolListWidgetState();
// }

// class _SymbolListWidgetState extends State<SymbolListWidget> {
//   List<MultiChooseRadioModel> sampleData = [];
//   @override
//   void initState() {
//     for (var element in widget.symbolList) {
//       sampleData.add(MultiChooseRadioModel(false, element));
//     }

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: sampleData.length,
//       shrinkWrap: true,
//       itemBuilder: (BuildContext context, int index) {
//         return InkWell(
//           splashColor: Colors.transparent,
//           onTap: () {
//             setState(() {
//               sampleData.forEach((element) => element.isSelected = false);
//               sampleData[index].isSelected = true;

//               widget.selectedSymbol(sampleData[index].text);
//             });
//           },
//           child: RadioItem(sampleData[index]),
//         );
//       },
//     );
//   }
// }

// class RadioItem extends StatelessWidget {
//   final MultiChooseRadioModel _item;
//   RadioItem(this._item);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           _item.isSelected ? const RadioRowSelectedIcon() : const RadioRowUnSelectedIcon(),
//           Container(
//             margin: const EdgeInsets.only(left: Grid.s),
//             child: Text(
//               _item.text,
//               style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                     fontSize: 14,
//                     color: PColor.lightHigh,
//                   ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

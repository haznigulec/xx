import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_add_data_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_blockage_model.dart';
import 'package:piapiri_v2/app/ipo/widgets/ipo_financial_instrument_data_source.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class IpoBlockageListBottomSheet extends StatefulWidget {
  final String deputyName;
  final String ipoId;
  final String paymentTypeName;
  final int paymentTypeId;
  final double ipoPrice;
  final String selectedAccount;
  final IpoAddDataModel addData;
  final Function(IpoAddDataModel) onChangedAddData;
  final bool fromUpdatePage;
  final double? demandedAmount;
  const IpoBlockageListBottomSheet({
    super.key,
    required this.deputyName,
    required this.ipoId,
    required this.paymentTypeName,
    required this.ipoPrice,
    required this.paymentTypeId,
    required this.selectedAccount,
    required this.addData,
    required this.onChangedAddData,
    this.fromUpdatePage = false,
    this.demandedAmount,
  });

  @override
  State<IpoBlockageListBottomSheet> createState() => _IpoBlockageListBottomSheetState();
}

// Blokaj
class _IpoBlockageListBottomSheetState extends State<IpoBlockageListBottomSheet> {
  late IpoBloc _bloc;
  FinancialInstrumentDataSource? _dataSource;
  late List<dynamic> columnNames;
  double _enteredValue = 0.0;
  double _remainingValue = 0.0;
  final DataGridController _dataGridController = DataGridController();
  bool _isKeyboardClosed = true;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _bloc = getIt<IpoBloc>();
    _focusNode.addListener(_onFocusChange);

    _bloc.add(
      GetBlockageEvent(
        customerId: widget.selectedAccount.split('-')[0],
        accountId: widget.selectedAccount.split('-')[1],
        ipoId: widget.ipoId,
        paymentType: widget.paymentTypeId,
      ),
    );
    _remainingValue = widget.ipoPrice;
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardClosed = !_focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: PBlocConsumer<IpoBloc, IpoState>(
        bloc: _bloc,
        listenWhen: (previous, current) {
          return (previous.isLoading || previous.isFailed || previous.ipoBlockageModel == null) && current.isSuccess;
        },
        listener: (context, state) {
          _dataSource = FinancialInstrumentDataSource(
            controller: _dataGridController,
            financialInstrument: state.ipoBlockageModel!.financialInstrument!,
            amountText: '',
            paymentTypeId: widget.paymentTypeId,
            dividerColor: context.pColorScheme.line,
            demandedAmount: widget.demandedAmount,
            onChangeAmount: (String value) {
              setState(() {
                _isKeyboardClosed = false;

                _enteredValue = double.parse(value);
                _remainingValue = widget.ipoPrice - _enteredValue;
              });
            },
          );
        },
        builder: (context, state) {
          return state.isLoading || state.isFailed || state.ipoBlockageModel == null || _dataSource == null
              ? const PLoading()
              : state.ipoBlockageModel!.financialInstrument!.isEmpty
                  ? Center(
                      child: NoDataWidget(
                        message: L10n.tr(
                          'ipo_blockage_list_empty_alert_by_name',
                          args: [
                            L10n.tr(widget.paymentTypeName),
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Grid.s,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _middleColumnWidget(
                                          L10n.tr('ipo_amount'),
                                          MoneyUtils().readableMoney(widget.ipoPrice),
                                        ),
                                        _middleColumnWidget(
                                          L10n.tr('amount_entered'),
                                          MoneyUtils().readableMoney(_enteredValue),
                                        ),
                                        _middleColumnWidget(
                                          L10n.tr('amount_remaining'),
                                          MoneyUtils().readableMoney(
                                            _remainingValue < 0 ? 0 : _remainingValue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const PDivider(
                                      padding: EdgeInsets.only(
                                        top: Grid.s + Grid.xs,
                                      ),
                                    ),
                                    SfDataGrid(
                                      controller: _dataGridController,
                                      source: _dataSource!,
                                      navigationMode: GridNavigationMode.cell,
                                      headerRowHeight: 40,
                                      rowHeight: 60,
                                      columns: _getColumns(),
                                      verticalScrollPhysics: const BouncingScrollPhysics(),
                                      horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
                                      selectionMode: SelectionMode.none,
                                      shrinkWrapRows: true,
                                      gridLinesVisibility: GridLinesVisibility.none,
                                      headerGridLinesVisibility: GridLinesVisibility.none,
                                    ),
                                    SizedBox(height: _isKeyboardClosed ? 0 : kKeyboardHeight),
                                    const SizedBox(
                                      height: Grid.s,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          generalButtonPadding(
                            context: context,
                            leftPadding: 0,
                            rightPadding: 0,
                            child:
                                state.ipoBlockageModel != null && state.ipoBlockageModel!.financialInstrument!.isEmpty
                                    ? const SizedBox.shrink()
                                    : OrderApprovementButtons(
                                        approveButtonText: L10n.tr('kaydet'),
                                        onPressedApprove: _enteredValue == 0 ? null : () => _apply(state),
                                      ),
                          )
                        ],
                      ),
                    );
        },
      ),
    );
  }

  void _apply(IpoState state) async {
    if (_enteredValue < double.parse(widget.ipoPrice.toStringAsFixed(2))) {
      return PBottomSheet.show(
        context,
        titleWidget: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => router.maybePop(),
                child: SvgPicture.asset(
                  ImagesPath.chevron_left,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.paymentTypeName,
                style: context.pAppStyle.labelMed14textPrimary,
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Grid.m,
          children: [
            SvgPicture.asset(
              ImagesPath.alert_circle,
              width: 52,
              height: 52,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            Text(
              L10n.tr('ipo_blockage_less_alert'),
              textAlign: TextAlign.center,
              style: context.pAppStyle.labelReg16textPrimary,
            ),
            PButton(
              text: L10n.tr('update_blockage'),
              fillParentWidth: true,
              onPressed: () => router.maybePop(),
            ),
            const SizedBox(
              height: Grid.xs,
            ),
          ],
        ),
      );
    } else if (_enteredValue > double.parse(widget.ipoPrice.toStringAsFixed(2))) {
      return PBottomSheet.show(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImagesPath.alert_circle,
              width: 52,
              height: 52,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Grid.m,
              ),
              child: Text(
                L10n.tr('ipo_blockage_more_than_alert'),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    } else {
      List<Map<String, dynamic>> itemsToBlock = [];
      for (var element in _dataGridController.selectedRows) {
        // widget.paymentTypeId == 5 Fon blokaj ise
        FinancialInstrument? instrument = state.ipoBlockageModel!.financialInstrument?.firstWhere(
          (e) => widget.paymentTypeId == 5
              ? e.finInstName!.contains(element.getCells()[1].value.toString().split('-')[1])
              : e.finInstName == element.getCells()[1].value.toString(),
        );
        itemsToBlock.add({
          'finInstName': widget.paymentTypeId == 5
              ? instrument
                  ?.finInstName // Fon blokajları ismini gönderirken blokaj endpointinden geldiği şekilde requeste göndermek için kontrol ekledik.
              : element.getCells()[1].value.toString(),
          'demandAmount': element.getCells()[3].value,
          'rationalAmount': element.getCells()[2].value,
          'typeCode': instrument?.typeCode,
          'price': instrument?.price,
          'balance': instrument?.balance,
          'rationalDemandAmount': instrument?.rationalDemandAmount,
        });
      }

      widget.addData.itemsToBlock = itemsToBlock;

      widget.onChangedAddData(widget.addData);

      await router.maybePop();

      if (!widget.fromUpdatePage) {
        await router.maybePop();
      }

      return;
    }
  }

  List<GridColumn> _getColumns() {
    return <GridColumn>[
      GridColumn(
        allowSorting: false,
        maximumWidth: 40,
        columnName: 'checkbox',
        allowEditing: false,
        label: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.pColorScheme.line,
                width: 1,
              ),
            ),
          ),
          child: Text(
            widget.paymentTypeId == 5
                ? L10n.tr('fund')
                : widget.paymentTypeId == 4
                    ? L10n.tr('currency')
                    : L10n.tr('hisse'),
            textAlign: TextAlign.left,
            style: context.pAppStyle.labelMed12textSecondary,
          ),
        ),
      ),
      GridColumn(
        columnWidthMode: ColumnWidthMode.fill,
        columnName: 'finInstName',
        allowEditing: false,
        label: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.pColorScheme.line,
                  width: 1,
                ),
              ),
            ),
            child: const Text('')),
      ),
      GridColumn(
        columnWidthMode: ColumnWidthMode.fill,
        columnName: 'rationalAmount',
        allowEditing: false,
        label: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.pColorScheme.line,
                width: 1,
              ),
            ),
          ),
          child: Text(
            L10n.tr('bakiye'),
            textAlign: TextAlign.center,
            style: context.pAppStyle.labelMed12textSecondary,
          ),
        ),
      ),
      GridColumn(
        columnWidthMode: ColumnWidthMode.fill,
        allowEditing: true,
        allowFiltering: false,
        columnName: 'demandAmount',
        label: Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.pColorScheme.line,
                width: 1,
              ),
            ),
          ),
          child: Text(
            L10n.tr('blockage_amount'),
            textAlign: TextAlign.right,
            style: context.pAppStyle.labelMed12textSecondary,
          ),
        ),
      ),
    ];
  }

  Widget _middleColumnWidget(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.pAppStyle.labelMed12textSecondary,
        ),
        Text(
          '₺$value',
          style: context.pAppStyle.labelMed14textPrimary,
        ),
        const SizedBox(
          height: Grid.s,
        ),
      ],
    );
  }
}

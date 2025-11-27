import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/enqura/model/account_setting_status_model.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_picker_model.dart';
import 'package:piapiri_v2/app/enqura/model/item_list_model.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_page_steps.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_leave_page.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_picker_widget.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_text_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class EnquraFinancialInformationPage extends StatefulWidget {
  final String title;

  const EnquraFinancialInformationPage({
    super.key,
    required this.title,
  });

  @override
  State<EnquraFinancialInformationPage> createState() => _EnquraFinancialInformationPageState();
}

class _EnquraFinancialInformationPageState extends State<EnquraFinancialInformationPage> {
  late EnquraBloc _enquraBloc;
  bool _backButtonPressedDisposeClosedPage = true;
  late EnquraCreateUserModel _initialUser;
  final List<EnquraPickerModel> pageItems = [
    EnquraPickerModel(
      label: L10n.tr('job'),
      selectableItems: [],
    ),
    EnquraPickerModel(
      label: L10n.tr('is_there_any_company_founder'),
      selectableItems: [
        ItemListModel(
          key: L10n.tr('there_is_not'),
          value: false,
        ),
        ItemListModel(
          key: L10n.tr('there_is'),
          value: true,
        ),
      ],
    ),
    EnquraPickerModel(
      label: L10n.tr('company_name'),
      selectableItems: [],
      isVisible: false,
      isTextField: true,
    ),
    EnquraPickerModel(
      label: L10n.tr('company_equity_percents'),
      selectableItems: [],
      isVisible: false,
      isTextField: true,
      keyboaryIsNumber: true,
      minValue: 0,
      maxValue: 100,
    ),
    EnquraPickerModel(
      label: L10n.tr('foreign_tax_is_required'),
      selectableItems: [
        ItemListModel(
          key: L10n.tr('there_is_not'),
          value: false,
        ),
        ItemListModel(
          key: L10n.tr('there_is'),
          value: true,
        ),
      ],
    ),
    EnquraPickerModel(
      label: L10n.tr('foreign_tax_required_country'),
      selectableItems: [],
      isVisible: false,
    ),
    EnquraPickerModel(
      label: L10n.tr('foreign_tax_no'),
      selectableItems: [],
      isVisible: false,
      isTextField: true,
      keyboaryIsNumber: true,
      minLength: 11,
      maxLength: 11,
    ),
    EnquraPickerModel(
      label: L10n.tr('foreign_sgk_no'),
      selectableItems: [],
      isVisible: false,
      isTextField: true,
      keyboaryIsNumber: true,
      minLength: 9,
      maxLength: 9,
    ),
    EnquraPickerModel(
      label: L10n.tr('foreign_ikn_no'),
      selectableItems: [],
      isVisible: false,
      isTextField: true,
      keyboaryIsNumber: true,
      minLength: 9,
      maxLength: 9,
    ),
    EnquraPickerModel(
      label: L10n.tr('nema_preferance'),
      selectableItems: [
        ItemListModel(
          key: L10n.tr('it_not_be'),
          value: false,
        ),
        ItemListModel(
          key: L10n.tr('it_be'),
          value: true,
        ),
      ],
    ),
  ];
  final ValueNotifier<bool> _isEnabledButton = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _enquraBloc = getIt<EnquraBloc>();
    getIt<Analytics>().track(
      AnalyticsEvents.financialInfoView,
    );
    if (_enquraBloc.state.professions?.isNotEmpty == true) {
      pageItems
          .firstWhere((e) => e.label == L10n.tr('job'))
          .selectableItems
          .addAll(_enquraBloc.state.professions!.map((e) => ItemListModel(key: e.value, value: e.key)).toList());
    }

    if (_enquraBloc.state.countries?.isNotEmpty == true) {
      pageItems
          .firstWhere((e) => e.label == L10n.tr('foreign_tax_required_country'))
          .selectableItems
          .addAll(_enquraBloc.state.countries!.map((e) => ItemListModel(key: e.value, value: e.key)).toList());
    }

    _fillData();
    _initialUser = _onCreateUserModel();
  }

  @override
  void dispose() {
    _isEnabledButton.dispose();
    super.dispose();
  }

  Future _onClosePage() async {
    bool isContinue = false;
    final latestUser = _onCreateUserModel();
    if (jsonEncode(_initialUser.toJson()) != jsonEncode(latestUser.toJson())) {
      getIt<Analytics>().track(
        AnalyticsEvents.financialInfoBackButton,
      );
      isContinue = await toEnquraOnboardingPage(context) ?? true;
    }

    if (isContinue) return;

    setState(() {
      _backButtonPressedDisposeClosedPage = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.maybePop();
    });
  }

  void _fillData() {
    final user = _enquraBloc.state.user;
    if (user != null) {
      if (user.occupation?.isNotEmpty == true) {
        final item = pageItems.firstWhere((e) => e.label == L10n.tr('job'));
        final selectedItem = item.selectableItems.where((e) => e.value == user.occupation).firstOrNull;
        if (selectedItem != null) {
          item.listValue = selectedItem;
        } else {
          item.listValue = ItemListModel(key: user.occupation ?? '', value: user.occupation ?? '');
        }
      }

      // Kurucu Olduğu Şirket Var mı ?
      if (user.isCompanyFounder != null) {
        final item = pageItems.firstWhere((e) => e.label == L10n.tr('is_there_any_company_founder'));
        final selectedItem = item.selectableItems.where((e) => e.value == user.isCompanyFounder).firstOrNull;
        if (selectedItem != null) {
          item.listValue = selectedItem;
          if (selectedItem.value == true) {
            final companyName = pageItems.firstWhere((e) => e.label == L10n.tr('company_name'));
            companyName.isVisible = true;
            companyName.textValue = user.companyName ?? '';
            final companyEquityPercents = pageItems.firstWhere((e) => e.label == L10n.tr('company_equity_percents'));
            companyEquityPercents.isVisible = true;
            final sharePercentage = (user.sharePercentage ?? 0);
            final hasFraction = sharePercentage % 1 != 0;
            companyEquityPercents.textValue =
                hasFraction ? sharePercentage.toString() : sharePercentage.toInt().toString();
          }
        }
      }

      //Yurt dışı vergi zorunluluğu var mı ?
      if (user.hasForeignTaxLiability != null) {
        final item = pageItems.firstWhere((e) => e.label == L10n.tr('foreign_tax_is_required'));
        final selectedItem = item.selectableItems.where((e) => e.value == user.hasForeignTaxLiability).firstOrNull;
        if (selectedItem != null) {
          item.listValue = selectedItem;
          if (selectedItem.value == true) {
            final foreignTaxRequiredCountry =
                pageItems.firstWhere((e) => e.label == L10n.tr('foreign_tax_required_country'));
            foreignTaxRequiredCountry.isVisible = true;
            final foreignTaxRequiredCountrySelectedItem =
                foreignTaxRequiredCountry.selectableItems.where((e) => e.value == user.foreignTaxCountry).firstOrNull;

            if (foreignTaxRequiredCountrySelectedItem != null) {
              foreignTaxRequiredCountry.listValue = foreignTaxRequiredCountrySelectedItem;
              final showFields = foreignTaxRequiredCountrySelectedItem.key.toUpperCase() == 'ABD'.toUpperCase();
              if (showFields) {
                final foreignSgkNo = pageItems.firstWhere((e) => e.label == L10n.tr('foreign_sgk_no'));
                foreignSgkNo.isVisible = true;
                foreignSgkNo.textValue = user.socialSecurityNumber;
                final foreignIknNo = pageItems.firstWhere((e) => e.label == L10n.tr('foreign_ikn_no'));
                foreignIknNo.isVisible = true;
                foreignIknNo.textValue = user.employerIdentificationNo ?? '';
              }
            }

            final foreignTaxNo = pageItems.firstWhere((e) => e.label == L10n.tr('foreign_tax_no'));
            foreignTaxNo.isVisible = true;
            foreignTaxNo.textValue = user.foreignTaxIdentificationNo ?? '';
          }
        }
      }

      //Nemalandırma
      if (user.profitSharePreference != null) {
        final item = pageItems.firstWhere((e) => e.label == L10n.tr('nema_preferance'));
        final selectedItem = item.selectableItems.where((e) => e.value == user.profitSharePreference).firstOrNull;
        if (selectedItem != null) {
          item.listValue = selectedItem;
        }
      }

      _checkButtonEnabled();
    }
  }

  void _checkButtonEnabled() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bool anyEmptyTextValue =
          pageItems.where((e) => e.isVisible && e.isTextField).any((e) => (e.textValue?.trim().isEmpty ?? true));

      // 2 textField dan geçerli olmayan var mı?
      final bool anyIsNotValidTextValue = pageItems
          .where((e) => e.isVisible && e.isTextField && e.minLength != null && e.maxLength != null)
          .any((e) => !(e.textValue?.trim().isNotEmpty == true &&
              e.textValue!.length >= e.minLength! &&
              e.textValue!.length <= e.maxLength!));

      // 3. Görünür + textField olmayanlardan listValue null olan var mı?
      final bool anyEmptyListValue =
          pageItems.where((e) => e.isVisible && !e.isTextField).any((e) => e.listValue == null);

      _isEnabledButton.value = !anyEmptyTextValue && !anyIsNotValidTextValue && !anyEmptyListValue;
    });
  }

  String? _getTextValue(String label) {
    return pageItems.firstWhere((e) => e.label == L10n.tr(label)).textValue?.trim();
  }

  dynamic _getListValueKey(String label, {bool returnTypeIsVal = true}) {
    if (returnTypeIsVal) return pageItems.firstWhere((e) => e.label == L10n.tr(label)).listValue?.value;
    return pageItems.firstWhere((e) => e.label == L10n.tr(label)).listValue?.key;
  }

  dynamic _getListValueValue(String label, {bool returnTypeIsVal = true}) {
    if (returnTypeIsVal) return pageItems.firstWhere((e) => e.label == L10n.tr(label)).listValue?.value;
    return pageItems.firstWhere((e) => e.label == L10n.tr(label)).listValue?.value;
  }

  EnquraCreateUserModel _onCreateUserModel() {
    //Meslek
    final selectedOccupation = _getListValueKey('job');
    //Kurucu Olduğu Şirket Var mı ?
    final isCompanyFounder = _getListValueKey('is_there_any_company_founder') as bool?;
    //Yurt dışı vergi zorunluluğu var mı ?
    final hasForeignTaxLiability = _getListValueKey('foreign_tax_is_required') as bool?;
    final foreignTaxCountry = _getListValueValue('foreign_tax_required_country', returnTypeIsVal: false) as String?;
    final foreignTaxCountryIsABD = foreignTaxCountry?.toUpperCase() == 'US';

    //Nemalandırma
    final profitShare = _getListValueKey('nema_preferance') as bool?;

    return EnquraCreateUserModel(
      occupation: selectedOccupation is String ? selectedOccupation : '',
      //Kurucu Olduğu Şirket Var mı ?
      isCompanyFounder: isCompanyFounder,
      companyName: isCompanyFounder == true ? _getTextValue('company_name') : '',
      sharePercentage: isCompanyFounder == true ? double.tryParse(_getTextValue('company_equity_percents') ?? '') : 0,
      //Yurt dışı vergi zorunluluğu var mı ?
      hasForeignTaxLiability: hasForeignTaxLiability,
      foreignTaxCountry: hasForeignTaxLiability == true ? foreignTaxCountry : '',
      foreignTaxIdentificationNo: hasForeignTaxLiability == true ? _getTextValue('foreign_tax_no') : '',
      socialSecurityNumber:
          hasForeignTaxLiability == true && foreignTaxCountryIsABD ? _getTextValue('foreign_sgk_no') : '',
      employerIdentificationNo:
          hasForeignTaxLiability == true && foreignTaxCountryIsABD ? _getTextValue('foreign_ikn_no') : '',
      profitSharePreference: profitShare,
      phoneNumber: _enquraBloc.state.phoneNumber,
      sessionNo: _enquraBloc.state.sessionNo,
      guid: _enquraBloc.state.guid,
      currentStep: EnquraPageSteps.financialInformation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PInnerAppBar(
          title: L10n.tr(widget.title),
          backButtonPressedDisposeClosedPage: _backButtonPressedDisposeClosedPage,
          backButtonPressedDisposeClosedFunction: () => _onClosePage(),
          onPressed: () => _onClosePage(),
        ),
        body: PBlocBuilder<EnquraBloc, EnquraState>(
          bloc: _enquraBloc,
          builder: (context, state) => state.isLoading
              ? const PLoading()
              : GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Grid.m,
                        right: Grid.m,
                      ),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: Grid.s + Grid.xs),
                        itemCount: pageItems.length,
                        itemBuilder: (context, index) => !pageItems[index].isVisible
                            ? const SizedBox.shrink()
                            : pageItems[index].isTextField
                                ? EnquraTextWidget(
                                    pickerModel: pageItems[index],
                                    onTextChanged: (textValue) {
                                      pageItems[index].textValue = textValue;
                                      _checkButtonEnabled();
                                    },
                                  )
                                : EnquraPickerWidget(
                                    pickerModel: pageItems[index],
                                    onSelectionChanged: (pickerModel) {
                                      setState(() {
                                        pageItems.removeAt(index);
                                        pageItems.insert(index, pickerModel);
                                      });

                                      if (pageItems[index].label == L10n.tr('is_there_any_company_founder')) {
                                        final showFields = pickerModel.listValue?.value == true;
                                        setState(() {
                                          pageItems.firstWhere((e) => e.label == L10n.tr('company_name')).isVisible =
                                              showFields;
                                          pageItems
                                              .firstWhere((e) => e.label == L10n.tr('company_equity_percents'))
                                              .isVisible = showFields;
                                        });
                                      } else if (pageItems[index].label == L10n.tr('foreign_tax_is_required')) {
                                        final showFields = pickerModel.listValue?.value == true;
                                        setState(() {
                                          pageItems
                                              .firstWhere((e) => e.label == L10n.tr('foreign_tax_required_country'))
                                              .isVisible = showFields;
                                          pageItems.firstWhere((e) => e.label == L10n.tr('foreign_tax_no')).isVisible =
                                              showFields;
                                          pageItems.firstWhere((e) => e.label == L10n.tr('foreign_sgk_no')).isVisible =
                                              showFields;
                                          pageItems.firstWhere((e) => e.label == L10n.tr('foreign_ikn_no')).isVisible =
                                              showFields;
                                        });
                                      } else if (pageItems[index].label == L10n.tr('foreign_tax_required_country')) {
                                        final showFields =
                                            pickerModel.listValue?.key.toUpperCase() == 'ABD'.toUpperCase();
                                        setState(() {
                                          pageItems.firstWhere((e) => e.label == L10n.tr('foreign_sgk_no')).isVisible =
                                              showFields;
                                          pageItems.firstWhere((e) => e.label == L10n.tr('foreign_ikn_no')).isVisible =
                                              showFields;
                                        });
                                      }

                                      _checkButtonEnabled();
                                    },
                                  ),
                      ),
                    ),
                  ),
                ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: Grid.m + Grid.xs,
              left: Grid.s,
              right: Grid.s,
            ),
            child: PBlocBuilder<EnquraBloc, EnquraState>(
              bloc: _enquraBloc,
              builder: (context, state) => ValueListenableBuilder<bool>(
                valueListenable: _isEnabledButton,
                builder: (context, isEnabled, child) {
                  return PButton(
                    text: L10n.tr('devam'),
                    fillParentWidth: true,
                    onPressed: !state.isLoading && isEnabled
                        ? () {
                            EnquraAccountSettingStatusModel? accounStatus = _enquraBloc.state.accountSettingStatus;
                            bool forceOldStatus = accounStatus?.identityVerification == 1 ||
                                accounStatus?.onlineContracts == 1 ||
                                accounStatus?.videoCall == 1;
                            final user = _onCreateUserModel();
                            if (forceOldStatus) {
                              PBottomSheet.showError(
                                context,
                                customImagePath: ImagesPath.info,
                                content: L10n.tr('enqura_changed_financial_info'),
                                showFilledButton: true,
                                showOutlinedButton: true,
                                outlinedButtonText: L10n.tr('vazgec'),
                                filledButtonText: L10n.tr('devam'),
                                onOutlinedButtonPressed: () => router.maybePop(),
                                onFilledButtonPressed: () {
                                  router.popAndPush(
                                    EnquraOtpRoute(
                                      user: user.copyWith(currentStep: EnquraPageSteps.financialInformation),
                                      onSuccess: () {
                                        router.maybePop();
                                        _enquraBloc.add(
                                          GetUserEvent(
                                            guid: _enquraBloc.state.guid ?? '',
                                            phoneNumber: _enquraBloc.state.phoneNumber ?? '',
                                            isFirstInitialize: false,
                                          ),
                                        );
                                        setState(() {
                                          _backButtonPressedDisposeClosedPage = false;
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          router.maybePop();
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              _enquraBloc.add(
                                CreateOrUpdateUserEvent(
                                  user: user,
                                  onSuccess: () {
                                    _enquraBloc.add(
                                      GetUserEvent(
                                        guid: _enquraBloc.state.guid ?? '',
                                        phoneNumber: _enquraBloc.state.phoneNumber ?? '',
                                        isFirstInitialize: false,
                                      ),
                                    );
                                    setState(() {
                                      _backButtonPressedDisposeClosedPage = false;
                                    });
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      router.maybePop();
                                    });
                                  },
                                ),
                              );
                            }
                          }
                        : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

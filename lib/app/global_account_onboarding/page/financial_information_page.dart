import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/checkbox_selection.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/custom_progress_bar.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/global_onboarding_textfield_widget.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/leave_page.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/personal_information_tile.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class FinancialInformationPage extends StatefulWidget {
  final String title;
  const FinancialInformationPage({
    super.key,
    required this.title,
  });

  @override
  State<FinancialInformationPage> createState() => _FinancialInformationPageState();
}

class _FinancialInformationPageState extends State<FinancialInformationPage> {
  late GlobalAccountOnboardingBloc _accountOnboardingBloc;
  bool _backButtonPressedDisposeClosedPage = true;
  bool _isAffiliatedFinra = false;
  bool _isControlPerson = false;
  bool _isPoliticallyExposed = false;
  bool _immediateFamilyExposed = false;
  String _selectTotalAssets = 'choose';
  String _selectEmploymentStatus = 'choose';
  String _selectFundingSource = 'choose';
  late TextEditingController _employerNameController;
  late TextEditingController _employerAddressController;
  late TextEditingController _employmentPositionController;
  @override
  void initState() {
    super.initState();
    _accountOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();
    _accountOnboardingBloc.add(
      AccountInfoEvent(
        listType: 1,
      ),
    );
    _employerNameController = TextEditingController();
    _employerAddressController = TextEditingController();
    _employmentPositionController = TextEditingController();
  }

  @override
  void dispose() {
    _employerNameController.dispose();
    _employerAddressController.dispose();
    _employmentPositionController.dispose();
    super.dispose();
  }

  bool _areAllConditionsMet() {
    return _isAffiliatedFinra &&
        _isControlPerson &&
        _isPoliticallyExposed &&
        _immediateFamilyExposed &&
        _selectTotalAssets != 'choose' &&
        _selectEmploymentStatus != 'choose' &&
        _selectFundingSource != 'choose';
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
        appBar: PInnerAppBar(
          title: L10n.tr(widget.title),
          //Device'ın back tuşuna engel olması durumu için eklendi
          backButtonPressedDisposeClosedPage: _backButtonPressedDisposeClosedPage,
          backButtonPressedDisposeClosedFunction: () => toGlobalOnboardingPage(context),
          onPressed: () => toGlobalOnboardingPage(context),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Grid.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: Grid.m + Grid.xs),
                        CustomProgressBar(
                          value: 2 / 3,
                          progressText: '2/3',
                          title: L10n.tr('financialInformation'),
                        ),
                        const SizedBox(height: Grid.l / 2),
                        PersonalInformationTile(
                          //Tekrar build olması için zorunlu
                          key: UniqueKey(),
                          keys: '${L10n.tr('employmentStatus')}*',
                          editable: true,
                          value: L10n.tr(_selectEmploymentStatus),
                          onTap: () {
                            PBottomSheet.show(
                              context,
                              title: L10n.tr('employmentStatus'),
                              titlePadding: const EdgeInsets.only(
                                top: Grid.m,
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => const PDivider(),
                                itemCount: globalOnboardingEmploymentStatus.length,
                                itemBuilder: (context, index) => BottomsheetSelectTile(
                                  title: L10n.tr(
                                    globalOnboardingEmploymentStatus[index],
                                  ),
                                  isSelected: _selectEmploymentStatus == globalOnboardingEmploymentStatus[index],
                                  value: globalOnboardingEmploymentStatus[index],
                                  onTap: (title, value) {
                                    setState(() {
                                      _selectEmploymentStatus = value;
                                      if (_selectEmploymentStatus != globalOnboardingEmploymentStatus[0]) {
                                        _employerNameController.clear();
                                        _employerAddressController.clear();
                                        _employmentPositionController.clear();
                                      }
                                    });
                                    router.maybePop();
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        if (_selectEmploymentStatus == 'employed') ...[
                          GlobalOnboardingTextfieldWidget(
                            controller: _employerNameController,
                            editable: true,
                            keys: L10n.tr('employerName'),
                            isEnabled: true,
                            isShowSuffixIcon: false,
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          GlobalOnboardingTextfieldWidget(
                            controller: _employerAddressController,
                            editable: true,
                            keys: L10n.tr('employerAddress'),
                            isEnabled: true,
                            isShowSuffixIcon: false,
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          GlobalOnboardingTextfieldWidget(
                            controller: _employmentPositionController,
                            editable: true,
                            keys: L10n.tr('employmentPosition'),
                            isEnabled: true,
                            isShowSuffixIcon: false,
                          ),
                        ],
                        const SizedBox(height: Grid.m),
                        PersonalInformationTile(
                          //Tekrar build olması için zorunlu
                          key: UniqueKey(),
                          keys: '${L10n.tr('totalAssets')}*',
                          editable: true,
                          value: L10n.tr(_selectTotalAssets),
                          onTap: () {
                            PBottomSheet.show(
                              context,
                              title: L10n.tr('totalAssets'),
                              titlePadding: const EdgeInsets.only(
                                top: Grid.m,
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: globalOnboardingTotalAssets.length,
                                separatorBuilder: (context, index) => const PDivider(),
                                itemBuilder: (context, index) => BottomsheetSelectTile(
                                  title: '\$${L10n.tr(
                                    globalOnboardingTotalAssets[index],
                                  )}',
                                  value: globalOnboardingTotalAssets[index],
                                  isSelected: _selectTotalAssets == globalOnboardingTotalAssets[index],
                                  onTap: (title, value) {
                                    setState(() {
                                      _selectTotalAssets = value;
                                    });
                                    router.maybePop();
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: Grid.m),
                        PersonalInformationTile(
                          //Tekrar build olması için zorunlu
                          key: UniqueKey(),
                          keys: '${L10n.tr('fundingSource')}*',
                          editable: true,
                          value: L10n.tr(_selectFundingSource),
                          onTap: () {
                            PBottomSheet.show(
                              context,
                              title: L10n.tr('fundingSource'),
                              titlePadding: const EdgeInsets.only(
                                top: Grid.m,
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => const PDivider(),
                                itemCount: globalOnboardingFundingSource.length,
                                itemBuilder: (context, index) => BottomsheetSelectTile(
                                  title: L10n.tr(
                                    globalOnboardingFundingSource[index],
                                  ),
                                  isSelected: _selectFundingSource == globalOnboardingFundingSource[index],
                                  value: globalOnboardingFundingSource[index],
                                  onTap: (title, value) {
                                    setState(() {
                                      _selectFundingSource = value;
                                    });
                                    router.maybePop();
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: Grid.l),
                        CheckboxSection(
                          isAffiliatedFinra: _isAffiliatedFinra,
                          isControlPerson: _isControlPerson,
                          isPoliticallyExposed: _isPoliticallyExposed,
                          immediateFamilyExposed: _immediateFamilyExposed,
                          onAffiliatedFinraChanged: (value) => setState(
                            () => _isAffiliatedFinra = value ?? false,
                          ),
                          onControlPersonChanged: (value) => setState(
                            () => _isControlPerson = value ?? false,
                          ),
                          onPoliticallyExposedChanged: (value) => setState(
                            () => _isPoliticallyExposed = value ?? false,
                          ),
                          onImmediateFamilyExposedChanged: (value) => setState(
                            () => _immediateFamilyExposed = value ?? false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PButton(
                  text: L10n.tr(
                    'devam',
                  ),
                  fillParentWidth: true,
                  onPressed: _areAllConditionsMet()
                      ? () {
                          _accountOnboardingBloc.add(
                            UploadAccountInfoEvent(
                              isAffiliatedFinra: _isAffiliatedFinra,
                              isControlPerson: _isControlPerson,
                              isPoliticallyExposed: _isPoliticallyExposed,
                              immediateFamilyExposed: _immediateFamilyExposed,
                              totalAssets: L10n.tr(_selectTotalAssets),
                              employmentStatus: _selectEmploymentStatus,
                              fundingSource: _selectFundingSource,
                              employerName: _selectEmploymentStatus == 'employed' ? _employerNameController.text : null,
                              employerAddress:
                                  _selectEmploymentStatus == 'employed' ? _employerAddressController.text : null,
                              employmentPosition:
                                  _selectEmploymentStatus == 'employed' ? _employmentPositionController.text : null,
                              callback: (response) {
                                _accountOnboardingBloc.add(
                                  AccountSettingStatusEvent(),
                                );

                                setState(() {
                                  _backButtonPressedDisposeClosedPage = false;
                                });
                                //Sayfanın kapanabilir olmasına izin verdikten sonra sayfayı kapatıp yönlendirmeyi yapıyoruz.
                                WidgetsBinding.instance.addPostFrameCallback(
                                  (_) {
                                    router.popAndPush(
                                      OnlineContractsRoute(
                                        title: L10n.tr('global_account_onboarding'),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        }
                      : null,
                ),
                const SizedBox(
                  height: Grid.s,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

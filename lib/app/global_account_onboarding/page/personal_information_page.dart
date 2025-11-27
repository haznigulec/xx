import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_state.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/custom_progress_bar.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/leave_page.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/personal_information_tile.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/countries_model.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import '../../../common/utils/countries.dart';

@RoutePage()
class PersonalInformationPage extends StatefulWidget {
  final String title;
  const PersonalInformationPage({
    super.key,
    required this.title,
  });

  @override
  State<PersonalInformationPage> createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  late GlobalAccountOnboardingBloc _accountOnboardingBloc;
  bool _backButtonPressedDisposeClosedPage = true;
  bool _isListViewVisible = false;
  String _selectedCountryOfCitizenship = L10n.tr('choose');
  String _selectedCountryOfTaxResidence = L10n.tr('choose');
  List<CountriesModel> _sortedCountries = [];
  @override
  void initState() {
    _accountOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();
    _sortedCountries = [...countries];
    _sortedCountries.sort((a, b) => a.tr.compareTo(b.tr));
    CountriesModel turkey = _sortedCountries.firstWhere((e) => e.iso == 'TR');
    _sortedCountries.remove(turkey);
    _sortedCountries.insert(0, turkey);

    _accountOnboardingBloc.add(
      AccountInfoEvent(
        listType: 0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: PBlocBuilder<GlobalAccountOnboardingBloc, GlobalAccountOnboardingState>(
        bloc: _accountOnboardingBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr(widget.title),
              //Device'ın back tuşuna engel olması durumu için eklendi
              backButtonPressedDisposeClosedPage: _backButtonPressedDisposeClosedPage,
              backButtonPressedDisposeClosedFunction: () => toGlobalOnboardingPage(context),
              onPressed: () => toGlobalOnboardingPage(context),
            ),
            body: state.isLoading || state.accountInfo == null
                ? const PLoading()
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: Grid.m + Grid.xs),
                                  CustomProgressBar(
                                    value: 1 / 3,
                                    progressText: '1/3',
                                    title: L10n.tr('personalInformation'),
                                  ),
                                  const SizedBox(height: Grid.m + Grid.xs),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount: state.accountInfo!.toJson().length - 1,
                                    itemBuilder: (context, index) {
                                      final prioritizedKeys = [
                                        'countryOfCitizenship',
                                        'countryOfTaxResidence',
                                        ...state.accountInfo!.toJson().keys.where((key) =>
                                            key != 'countryOfCitizenship' &&
                                            key != 'countryOfTaxResidence' &&
                                            key != 'alpacaCustomerAgreement'),
                                      ];

                                      if (index >= 2 && !_isListViewVisible) {
                                        return const SizedBox.shrink();
                                      }

                                      final key = prioritizedKeys[index];
                                      final value = key == 'countryOfCitizenship'
                                          ? _selectedCountryOfCitizenship
                                          : key == 'countryOfTaxResidence'
                                              ? _selectedCountryOfTaxResidence
                                              : state.accountInfo!.toJson()[key];

                                      return PersonalInformationTile(
                                        //tekrar build olması için zorunlu
                                        key: UniqueKey(),
                                        value: value,
                                        keys: key,
                                        editable: key == 'countryOfCitizenship' || key == 'countryOfTaxResidence',
                                        onTap: (key == 'countryOfCitizenship' || key == 'countryOfTaxResidence')
                                            ? () {
                                                PBottomSheet.show(
                                                  context,
                                                  title: L10n.tr(key),
                                                  titlePadding: const EdgeInsets.only(
                                                    top: Grid.m,
                                                  ),
                                                  child: SizedBox(
                                                    height: MediaQuery.sizeOf(context).height * .7,
                                                    child: ListView.separated(
                                                      itemCount: _sortedCountries.length,
                                                      shrinkWrap: true,
                                                      separatorBuilder: (context, index) => const PDivider(),
                                                      itemBuilder: (context, index) => BottomsheetSelectTile(
                                                        title: _sortedCountries[index].tr,
                                                        isSelected: key == 'countryOfCitizenship'
                                                            ? _selectedCountryOfCitizenship ==
                                                                _sortedCountries[index].tr
                                                            : _selectedCountryOfTaxResidence ==
                                                                _sortedCountries[index].tr,
                                                        onTap: (title, value) {
                                                          setState(
                                                            () {
                                                              if (key == 'countryOfCitizenship') {
                                                                _selectedCountryOfCitizenship = title;
                                                              } else if (key == 'countryOfTaxResidence') {
                                                                _selectedCountryOfTaxResidence = title;
                                                              }
                                                            },
                                                          );
                                                          router.maybePop();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            : null,
                                      );
                                    },
                                  ),
                                  PCustomPrimaryTextButton(
                                    margin: EdgeInsets.only(
                                      top: _isListViewVisible ? Grid.m : Grid.l,
                                      bottom: Grid.l,
                                    ),
                                    style: context.pAppStyle.labelMed16primary,
                                    text: _isListViewVisible
                                        ? L10n.tr(
                                            'daha_az_göster',
                                          )
                                        : L10n.tr(
                                            'daha_fazla_goster',
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        _isListViewVisible = !_isListViewVisible;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PButton(
                            text: L10n.tr('devam'),
                            fillParentWidth: true,
                            onPressed: _selectedCountryOfCitizenship != L10n.tr('choose') &&
                                    _selectedCountryOfTaxResidence != L10n.tr('choose')
                                ? () {
                                    _accountOnboardingBloc.add(
                                      UploadAccountInfoEvent(
                                        countryOfCitizenship: _sortedCountries
                                            .firstWhere((e) => e.tr == _selectedCountryOfCitizenship)
                                            .iso,
                                        countryOfTaxResidence: _sortedCountries
                                            .firstWhere((e) => e.tr == _selectedCountryOfTaxResidence)
                                            .iso,
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
                                                FinancialInformationRoute(
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
          );
        },
      ),
    );
  }
}

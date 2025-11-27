import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/textfields/text_field.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/app/enqura/model/item_list_model.dart';
import 'package:piapiri_v2/app/enqura/utils/enqualify_helper.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class EnquraAdressInfoPage extends StatefulWidget {
  const EnquraAdressInfoPage({super.key});

  @override
  State<EnquraAdressInfoPage> createState() => _EnquraAdressInfoPageState();
}

class _EnquraAdressInfoPageState extends State<EnquraAdressInfoPage> {
  late EnquraBloc _enquraBloc;

  ItemListModel? _selectedCity;
  ItemListModel? _selectedDistrict;

  late final TextEditingController _cityController;
  late final TextEditingController _districtController;
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingNoController = TextEditingController();

  final ValueNotifier<String> _neighborhoodNotifier = ValueNotifier('');
  final ValueNotifier<String> _streetNotifier = ValueNotifier('');
  final ValueNotifier<String> _buildingNoNotifier = ValueNotifier('');
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _enquraBloc = getIt<EnquraBloc>();
    getIt<Analytics>().track(
      AnalyticsEvents.addressInfoView,
    );

    _enquraBloc.add(GetCitiesEvent());

    final txtChoose = L10n.tr('choose');
    _cityController = TextEditingController(text: txtChoose);
    _districtController = TextEditingController(text: txtChoose);
    _neighborhoodController.addListener(_neighborhoodListener);
    _streetController.addListener(_streetListener);
    _buildingNoController.addListener(_buildingNoListener);
  }

  @override
  void dispose() {
    _neighborhoodController.removeListener(_neighborhoodListener);
    _streetController.removeListener(_streetListener);
    _buildingNoController.removeListener(_buildingNoListener);
    _cityController.dispose();
    _districtController.dispose();
    _neighborhoodController.dispose();
    _streetController.dispose();
    _buildingNoController.dispose();
    _neighborhoodNotifier.dispose();
    _streetNotifier.dispose();
    _buildingNoNotifier.dispose();
    super.dispose();
  }

  void _neighborhoodListener() {
    _neighborhoodNotifier.value = _neighborhoodController.text;
    _checkFormValidity();
  }

  void _streetListener() {
    _streetNotifier.value = _streetController.text;
    _checkFormValidity();
  }

  void _buildingNoListener() {
    _buildingNoNotifier.value = _buildingNoController.text;
    _checkFormValidity();
  }

  void _checkFormValidity() {
    _isValidNotifier.value = _validateForm();
  }

  bool _validateForm() {
    final requiredFieldsFilled = _selectedCity != null &&
        _selectedDistrict != null &&
        _neighborhoodNotifier.value.isNotEmpty &&
        _streetNotifier.value.isNotEmpty &&
        _buildingNoNotifier.value.isNotEmpty;
    return requiredFieldsFilled;
  }

  _selectCity() {
    PBottomSheet.show(
      context,
      title: L10n.tr('city'),
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _enquraBloc.state.cities?.length ?? 0,
        separatorBuilder: (context, i) => const PDivider(),
        itemBuilder: (context, i) {
          final option = _enquraBloc.state.cities![i];
          return BottomsheetSelectTile(
            title: option.value,
            isSelected: _selectedCity?.key == option.key,
            value: option.value,
            onTap: (title, value) {
              Navigator.pop(context);
              if (_selectedCity?.key != option.key) {
                setState(
                  () {
                    _selectedCity = option;
                    _cityController.text = option.value;
                    _selectedDistrict = null;
                    _districtController.text = L10n.tr('choose');
                    _enquraBloc.add(GetDistrictEvent(cityCode: option.key));
                  },
                );
                WidgetsBinding.instance.addPostFrameCallback((_) => _checkFormValidity());
              }
            },
          );
        },
      ),
    );
  }

  _selectDistrict() {
    PBottomSheet.show(
      context,
      title: L10n.tr('district'),
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _enquraBloc.state.districts?.length ?? 0,
        separatorBuilder: (context, i) => const PDivider(),
        itemBuilder: (context, i) {
          final option = _enquraBloc.state.districts![i];
          return BottomsheetSelectTile(
            title: option.value,
            isSelected: _selectedDistrict?.key == option.key,
            value: option.value,
            onTap: (title, value) {
              Navigator.pop(context);
              if (_selectedDistrict?.key != option.key) {
                setState(
                  () {
                    _selectedDistrict = option;
                    _districtController.text = option.value;
                  },
                );
                WidgetsBinding.instance.addPostFrameCallback((_) => _checkFormValidity());
              }
            },
          );
        },
      ),
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
        resizeToAvoidBottomInset: false,
        appBar: PInnerAppBar(
          dividerHeight: 0,
          title: L10n.tr('adress_info'),
        ),
        body: PBlocBuilder<EnquraBloc, EnquraState>(
          bloc: _enquraBloc,
          builder: (context, state) => state.isLoading
              ? const Center(
                  child: PLoading(),
                )
              : GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(Grid.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: Grid.m,
                                children: [
                                  GestureDetector(
                                    onTap: () => _selectCity(),
                                    child: PTextField(
                                      label: L10n.tr('city'),
                                      labelColor: context.pColorScheme.textSecondary,
                                      enabled: false,
                                      controller: _cityController,
                                      hasText: _selectedCity != null,
                                      textStyle: _selectedCity == null
                                          ? context.pAppStyle.labelMed16primary
                                          : context.pAppStyle.labelMed16textPrimary,
                                      suffixWidget: Transform.scale(
                                        scale: 0.4,
                                        child: SvgPicture.asset(
                                          ImagesPath.chevron_down,
                                          width: Grid.m,
                                          height: Grid.m,
                                          colorFilter: ColorFilter.mode(
                                            _selectedCity != null
                                                ? context.pColorScheme.textPrimary
                                                : context.pColorScheme.primary,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _selectedCity != null ? () => _selectDistrict() : null,
                                    child: PTextField(
                                      label: L10n.tr('district'),
                                      labelColor: context.pColorScheme.textSecondary,
                                      enabled: false,
                                      controller: _districtController,
                                      hasText: _selectedDistrict != null,
                                      textStyle: _selectedDistrict == null
                                          ? context.pAppStyle.labelMed16primary
                                          : context.pAppStyle.labelMed16textPrimary,
                                      suffixWidget: Transform.scale(
                                        scale: 0.4,
                                        child: SvgPicture.asset(
                                          ImagesPath.chevron_down,
                                          width: Grid.m,
                                          height: Grid.m,
                                          colorFilter: ColorFilter.mode(
                                            _selectedDistrict != null
                                                ? context.pColorScheme.textPrimary
                                                : context.pColorScheme.primary,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: _neighborhoodNotifier,
                                    builder: (context, value, child) => PTextField(
                                      controller: _neighborhoodController,
                                      label: L10n.tr('neighborhood'),
                                      labelColor: context.pColorScheme.textSecondary,
                                      hasText: value.isNotEmpty,
                                    ),
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: _streetNotifier,
                                    builder: (context, value, child) => PTextField(
                                      controller: _streetController,
                                      label: L10n.tr('street'),
                                      labelColor: context.pColorScheme.textSecondary,
                                      hasText: value.isNotEmpty,
                                    ),
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: _buildingNoNotifier,
                                    builder: (context, value, child) => PTextField(
                                      controller: _buildingNoController,
                                      maxLength: 11,
                                      label: L10n.tr('building_no'),
                                      labelColor: context.pColorScheme.textSecondary,
                                      hasText: value.isNotEmpty,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
        persistentFooterButtons: [
          ValueListenableBuilder<bool>(
            valueListenable: _isValidNotifier,
            builder: (context, isValid, child) => PButton(
              text: L10n.tr('devam'),
              fillParentWidth: true,
              onPressed: !isValid
                  ? null
                  : () async {
                      _enquraBloc.add(
                        CreateOrUpdateUserEvent(
                          user: EnquraCreateUserModel(
                            phoneNumber: _enquraBloc.state.user?.phoneNumber ?? '',
                            city: _selectedCity?.value ?? '',
                            district: _selectedDistrict?.value ?? '',
                            neighborhood: _neighborhoodController.text,
                            street: _streetController.text,
                            apartmentNo: _buildingNoController.text,
                          ),
                        ),
                      );

                      await EnqualifyHelper.postIntegrationAddRequest(
                        'Session',
                        _enquraBloc.state.startIntegration?.referanceCode ?? '',
                        jsonEncode({
                          'cityCode': _selectedCity?.key ?? '',
                          'cityDescription': _selectedCity?.value ?? '',
                          'districtCode': _selectedDistrict?.key ?? '',
                          'districtDescription': _selectedDistrict?.value ?? '',
                          'manualAdress': [
                            _neighborhoodController.text,
                            _streetController.text,
                            _buildingNoController.text,
                            _selectedDistrict?.value ?? '',
                            _selectedCity?.value ?? ''
                          ].where((e) => e.isNotEmpty).join(', '),
                        }),
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _enquraBloc.add(UpdateManualAdresRequiredEvent(manualAdresRequired: false));
                        router.maybePop();
                      });
                    },
            ),
          ),
        ],
      ),
    );
  }
}

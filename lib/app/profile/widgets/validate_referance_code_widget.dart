import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/profile/bloc/profile_referance_bloc.dart';
import 'package:piapiri_v2/app/profile/bloc/profile_referance_event.dart';
import 'package:piapiri_v2/app/profile/bloc/profile_referance_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/textfields/custom_text_form_field.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ValidateReferanceCodeWidget extends StatefulWidget {
  const ValidateReferanceCodeWidget({
    super.key,
  });

  @override
  State<ValidateReferanceCodeWidget> createState() => _ValidateReferanceCodeWidgetState();
}

class _ValidateReferanceCodeWidgetState extends State<ValidateReferanceCodeWidget> {
  late EnquraBloc _enquraBloc;
  late ProfileReferanceBloc _profileReferanceBloc;
  late final TextEditingController _referanceCodeController;
  bool _isEnabled = false;
  String _errorMessage = "";

  void _validateReferenceCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      setState(() {
        _isEnabled = false;
        _errorMessage = L10n.tr('referance_code_is_required');
      });
      return;
    }

    final refCode = value.trim();
    final regex = RegExp(r'^REF-\d+[A-Z]$', caseSensitive: true);
    if (!regex.hasMatch(refCode)) {
      setState(() {
        _isEnabled = false;
        _errorMessage = L10n.tr('wrong_referance_code');
      });
      return;
    }

    setState(() {
      _isEnabled = true;
      _errorMessage = '';
    });
  }

  @override
  void initState() {
    _enquraBloc = getIt<EnquraBloc>();
    _profileReferanceBloc = getIt<ProfileReferanceBloc>();
    _referanceCodeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _referanceCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: PBlocBuilder<ProfileReferanceBloc, ProfileReferanceState>(
        bloc: _profileReferanceBloc,
        builder: (context, appInfoState) => appInfoState.isLoading
            ? Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Grid.l,
                ),
                alignment: Alignment.center,
                color: context.pColorScheme.transparent,
                child: const CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImagesPath.hediye,
                    width: Grid.xl,
                    height: Grid.xl,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    height: Grid.m,
                  ),
                  Text(
                    L10n.tr('shared_referance_code_message'),
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  const SizedBox(
                    height: Grid.m,
                  ),
                  CustomTextFormField(
                    controller: _referanceCodeController,
                    label: L10n.tr('referance_code'),
                    backgroundColor: context.pColorScheme.card,
                    textStyle: context.pAppStyle.labelMed14textPrimary,
                    labelStyle: context.pAppStyle.labelReg14textSecondary,
                    errorText: _errorMessage,
                    onTextChanged: (value) {
                      _validateReferenceCode(value);
                    },
                  ),
                  const SizedBox(
                    height: Grid.m,
                  ),
                  PBlocBuilder<EnquraBloc, EnquraState>(
                    bloc: _enquraBloc,
                    builder: (context, enquraState) => PButton(
                      text: L10n.tr('kaydet'),
                      fillParentWidth: true,
                      loading: enquraState.isLoading || appInfoState.isLoading,
                      onPressed: _isEnabled && !enquraState.isLoading && !appInfoState.isLoading
                          ? () {
                              _enquraBloc.add(
                                EnquraCheckReferanceCodeEvent(
                                  refCode: _referanceCodeController.text,
                                  callBack: (isValid) {
                                    if (isValid) {
                                      _profileReferanceBloc.add(
                                        GetApplicationSettingsByKeyAndCustomerExtIdEvent(
                                          budyReferanceCode: _referanceCodeController.text,
                                          onSuccessCallback: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

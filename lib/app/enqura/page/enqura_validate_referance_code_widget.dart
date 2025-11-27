import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/textfields/custom_text_form_field.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EnquraValidateReferanceCodeWidget extends StatefulWidget {
  const EnquraValidateReferanceCodeWidget({
    super.key,
  });

  @override
  State<EnquraValidateReferanceCodeWidget> createState() => _EnquraValidateReferanceCodeWidgetState();
}

class _EnquraValidateReferanceCodeWidgetState extends State<EnquraValidateReferanceCodeWidget> {
  late EnquraBloc _enquraBloc;
  late final TextEditingController _referanceCodeController;
  bool _isEnabled = false;
  String _errorMessage = '';

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
      child: PBlocBuilder<EnquraBloc, EnquraState>(
        bloc: _enquraBloc,
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: Grid.s + Grid.xs,
            ),
            SvgPicture.asset(
              ImagesPath.hediye,
              width: 52,
              height: 52,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              height: Grid.m + Grid.xs,
            ),
            Text(
              L10n.tr('referance_code_validation_message'),
              textAlign: TextAlign.center,
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
              labelStyle: context.pAppStyle.labelReg14textPrimary,
              errorText: _errorMessage,
              onTextChanged: (value) {
                _validateReferenceCode(value);
              },
            ),
            const SizedBox(
              height: Grid.m,
            ),
            PButton(
              text: L10n.tr('kaydet'),
              fillParentWidth: true,
              loading: state.isLoading,
              onPressed: _isEnabled && !state.isLoading
                  ? () {
                      _enquraBloc.add(
                        EnquraCheckReferanceCodeEvent(
                          refCode: _referanceCodeController.text,
                          callBack: (isValid) {
                            if (isValid) {
                              Navigator.pop(
                                context,
                                _referanceCodeController.text,
                              );
                            }
                          },
                        ),
                      );
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

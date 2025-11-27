import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:path_provider/path_provider.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_bloc.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_event.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_state.dart';
import 'package:piapiri_v2/app/money_transfer/model/money_transfer_enum.dart';
import 'package:piapiri_v2/app/money_transfer/model/virement_institution_model.dart';
import 'package:piapiri_v2/app/money_transfer/utils/utils.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/institution_list_widget.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class VirementPage extends StatefulWidget {
  const VirementPage({super.key});

  @override
  State<VirementPage> createState() => _VirementPageState();
}

class _VirementPageState extends State<VirementPage> {
  VirementInstitutionModel? _selectedInstitution;
  final List<String> _attachments = [];
  late MoneyTransferBloc _moneyTransferBloc;

  @override
  void initState() {
    _moneyTransferBloc = getIt<MoneyTransferBloc>();
    _moneyTransferBloc.add(
      GetVirementInstitutionsEvent(),
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
      child: Scaffold(
        appBar: PInnerAppBar(
          title: L10n.tr(
            MoneyTransferEnum.transferOfSharesFromAnotherInstitution.name,
          ),
        ),
        body: PBlocBuilder<MoneyTransferBloc, MoneyTransferState>(
          bloc: _moneyTransferBloc,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: Shimmerize(
                enabled: state.isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Grid.l - Grid.xs,
                    ),
                    Text(
                      L10n.tr('virman_desc'),
                      textAlign: TextAlign.start,
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    const SizedBox(
                      height: Grid.l,
                    ),
                    InkWell(
                      onTap: () {
                        PBottomSheet.show(
                          context,
                          title: L10n.tr('institution_selection'),
                          titlePadding: const EdgeInsets.only(
                            top: Grid.m,
                          ),
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.7,
                            child: InstitutionListWidget(
                              institutionList: state.virementInstitutions,
                              onSelectedInstitution: (selectedInstitution) {
                                setState(() {
                                  _selectedInstitution = selectedInstitution;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            _selectedInstitution?.institutionName.toCapitalizeCaseTr ?? L10n.tr('kurum_seciniz'),
                            style: context.pAppStyle.labelMed14primary,
                          ),
                          const SizedBox(
                            width: Grid.xs,
                          ),
                          SvgPicture.asset(
                            ImagesPath.chevron_down,
                            width: 15,
                            height: 15,
                            colorFilter: ColorFilter.mode(
                              context.pColorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_selectedInstitution != null) ...[
                      const SizedBox(
                        height: Grid.l,
                      ),
                      InkWell(
                        onTap: () async {
                          Uint8List pdfFile = await Utils.createVirementPDF(
                            _selectedInstitution?.institutionName ?? '',
                          );
                          router.push(
                            VirementViewPdfRoute(
                              uint8List: pdfFile,
                              selectedInstitution: _selectedInstitution,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              L10n.tr('investor_instruction_form'),
                              style: context.pAppStyle.labelMed14primary,
                            ),
                            const SizedBox(
                              width: Grid.xs,
                            ),
                            SvgPicture.asset(
                              ImagesPath.fileInfo,
                              width: 15,
                              height: 15,
                              colorFilter: ColorFilter.mode(
                                context.pColorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Grid.l,
                      ),
                      PInfoWidget(
                        infoText: L10n.tr('instruction_created_info'),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: generalButtonPadding(
          context: context,
          child: PButton(
            text: L10n.tr('create_email'),
            fillParentWidth: true,
            onPressed: _selectedInstitution == null ? null : () => _sendMail(),
          ),
        ),
      ),
    );
  }

  void _sendMail() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDocumentDir.path}/Piapiri_Virman.pdf';
    final file = File(filePath);

    Uint8List pdfFile = await Utils.createVirementPDF(
      _selectedInstitution?.institutionName ?? '',
    );
    await file.writeAsBytes(pdfFile);
    _attachments.add(filePath);

    final Email email = Email(
      body: 'Sayın Yetkili,\nEkteki talebimin işleme alınmasını rica ederim.\nTeşekkürler.',
      subject: 'Virman Talebi',
      recipients: [
        _selectedInstitution?.institutionEmail ?? '',
      ],
      attachmentPaths: _attachments,
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      if (error is PlatformException && error.code == 'not_available') {
        /// Kullanıcının cihazında e-posta uygulaması yoksa uyarı gösteriyoruz.
        return PBottomSheet.showError(
          NavigatorKeys.navigatorKey.currentContext ?? context,
          content: L10n.tr(
            'no_email_app_found',
            args: [
              _selectedInstitution?.institutionEmail ?? '',
            ],
          ),
          showFilledButton: true,
          filledButtonText: L10n.tr('tamam'),
          onFilledButtonPressed: () => router.maybePop(),
        );
      } else {
        return PBottomSheet.showError(
          NavigatorKeys.navigatorKey.currentContext ?? context,
          content: error.toString(),
        );
      }
    }
  }
}

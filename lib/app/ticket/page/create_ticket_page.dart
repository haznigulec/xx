import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_bloc.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_event.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_state.dart';
import 'package:piapiri_v2/app/ticket/widget/choosen_image_file_widget.dart';
import 'package:piapiri_v2/app/ticket/widget/file_picker_button.dart';
import 'package:piapiri_v2/app/ticket/widget/create_ticket_textfield.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class CreateTicketPage extends StatefulWidget {
  final String title;
  const CreateTicketPage({super.key, required this.title});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  List<File>? _files;
  List<String> _fileBaseNames = [];
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late TicketBloc _ticketBloc;
  List<String> fileUrlList = [];
  @override
  void initState() {
    _ticketBloc = getIt<TicketBloc>();
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
      child: PBlocBuilder<TicketBloc, TicketState>(
        bloc: _ticketBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: widget.title,
            ),
            persistentFooterButtons: [
              PButton(
                loading: state.isLoading,
                fillParentWidth: true,
                text: L10n.tr('create_ticket'),
                onPressed: state.isLoading || _contentController.text.isEmpty || _subjectController.text.isEmpty
                    ? null
                    : () async {
                        if (_files != null) {
                          for (File file in _files!) {
                            _ticketBloc.add(
                              TicketMessageAttachmentFile(
                                formFile: await MultipartFile.fromFile(
                                  file.path,
                                  filename: basename(file.path),
                                ),
                                onSuccess: (bool success, dynamic fileUrl) {
                                  if (success && fileUrl != null) {
                                    setState(() {
                                      fileUrlList.add(fileUrl);
                                      if (_contentController.text.isNotEmpty && fileUrlList.isNotEmpty) {
                                        _ticketBloc.add(
                                          AddTicketsEvent(
                                            subject: _subjectController.text,
                                            topic: _contentController.text,
                                            onSuccess: (ticketId) => _ticketBloc.add(
                                              SendTicketMessageEvent(
                                                content: _contentController.text,
                                                ticketId: ticketId,
                                                attachments: fileUrlList,
                                                onSuccess: (_) {
                                                  PBottomSheet.showError(
                                                    context,
                                                    content: L10n.tr('create_ticket_success_message'),
                                                    isSuccess: true,
                                                    showFilledButton: true,
                                                    filledButtonText: L10n.tr('show_ticket_list'),
                                                    onFilledButtonPressed: () {
                                                      router.pushAndPopUntil(
                                                        TicketRoute(
                                                          title: L10n.tr('hata_bildir_v2'),
                                                        ),
                                                        predicate: (route) =>
                                                            route.settings.name == ContactUsRoute.name,
                                                      );
                                                      fileUrlList.clear();
                                                    },
                                                  );
                                                },
                                                hasLogs: true,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                              ),
                            );
                          }
                        } else {
                          _ticketBloc.add(
                            AddTicketsEvent(
                              subject: _subjectController.text,
                              topic: _contentController.text,
                              onSuccess: (ticketId) => _ticketBloc.add(
                                SendTicketMessageEvent(
                                  content: _contentController.text,
                                  ticketId: ticketId,
                                  attachments: fileUrlList,
                                  onSuccess: (_) {
                                    PBottomSheet.showError(
                                      context,
                                      content: L10n.tr('create_ticket_success_message'),
                                      isSuccess: true,
                                      isDismissible: false,
                                      enableDrag: false,
                                      showFilledButton: true,
                                      filledButtonText: L10n.tr('show_ticket_list'),
                                      onFilledButtonPressed: () {
                                        router.pushAndPopUntil(
                                          TicketRoute(
                                            title: L10n.tr('hata_bildir_v2'),
                                          ),
                                          predicate: (route) => route.settings.name == ContactUsRoute.name,
                                        );
                                        fileUrlList.clear();
                                      },
                                    );
                                  },
                                  hasLogs: true,
                                ),
                              ),
                            ),
                          );
                        }
                      },
              ),
            ],
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10n.tr('profile_report_hint'),
                      style: context.pAppStyle.labelReg16textPrimary,
                    ),
                    const SizedBox(
                      height: Grid.m,
                    ),
                    CreateTicketTextField(
                      height: 50,
                      hintText: L10n.tr('konu'),
                      controller: _subjectController,
                      maxLength: 40,
                      keyboardType: null,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: Grid.m,
                    ),
                    CreateTicketTextField(
                      height: 200,
                      controller: _contentController,
                      hintText: L10n.tr('aciklama_giriniz'),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    _files != null
                        ? ChosenImageFileWidget(
                            fileBaseNames: _fileBaseNames,
                            onDelete: () => setState(
                              () {
                                _files = null;
                              },
                            ),
                          )
                        : FilePickerButton(
                            hasFiles: _files != null,
                            onPickFile: () => _pickFiles(
                              context,
                              FileType.media,
                            ),
                            onPickImage: () => _pickFiles(
                              context,
                              FileType.any,
                            ),
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

  Future<void> _pickFiles(context, FileType type) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: type,
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        int maxSizeInBytes = 10 * 1024 * 1024;
        if (file.lengthSync() <= maxSizeInBytes) {
          setState(() {
            _files = [file];
            _fileBaseNames = [basename(file.path)];
          });
          router.maybePop();
        } else {
          PBottomSheet.showError(
            context,
            content: L10n.tr('fileSizeLarge'),
          );
          return;
        }
      }
    } catch (e) {
      PBottomSheet.showError(
        context,
        content: '${L10n.tr('filePickerError')}$e',
      );
      return;
    }
  }
}

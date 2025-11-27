import 'dart:io';

import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:path/path.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_bloc.dart';
import 'package:piapiri_v2/app/ticket/model/get_tickets_model.dart';
import 'package:piapiri_v2/app/ticket/widget/file_picker_button.dart';
import 'package:piapiri_v2/app/ticket/widget/send_message_button.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ActiveTicketTextField extends StatefulWidget {
  final GetTicketsModel ticket;
  final TicketBloc ticketBloc;
  final Function(bool) onHasFiles;

  const ActiveTicketTextField({
    super.key,
    required this.ticket,
    required this.ticketBloc,
    required this.onHasFiles,
  });

  @override
  State<ActiveTicketTextField> createState() => _ActiveTicketTextFieldState();
}

class _ActiveTicketTextFieldState extends State<ActiveTicketTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _fileName;
  List<File>? _files;

  Future<void> _pickFiles(BuildContext context, FileType type) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: type,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        int maxSizeInBytes = 3 * 1024 * 1024;
        if (file.lengthSync() <= maxSizeInBytes) {
          setState(() {
            _files = [file];
            _fileName = basename(file.path);
            widget.onHasFiles(true);
          });
          router.maybePop();
        } else {
          PBottomSheet.showError(
            NavigatorKeys.navigatorKey.currentContext ?? context,
            content: L10n.tr('fileSizeLarge'),
          );
        }
      }
    } catch (e) {
      PBottomSheet.showError(
        NavigatorKeys.navigatorKey.currentContext ?? context,
        content: '${L10n.tr('filePickerError')}$e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Grid.m,
        right: Grid.m,
        bottom: Grid.m,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_files != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
                vertical: Grid.s,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => setState(() {
                      _files = null;
                      _fileName = null;
                      widget.onHasFiles(false);
                    }),
                    child: SvgPicture.asset(
                      width: 17,
                      ImagesPath.trash,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                  Expanded(
                    child: Text(
                      _fileName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                  )
                ],
              ),
            ),
          ],
          KeyboardDoneAction(
            focusNode: _focusNode,
            child: TextField(
              focusNode: _focusNode,
              controller: _textEditingController,
              cursorColor: context.pColorScheme.primary,
              minLines: 1,
              maxLines: 4,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              style: context.pAppStyle.labelReg14textPrimary,
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Grid.l),
                  borderSide: BorderSide(color: context.pColorScheme.stroke),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Grid.l),
                  borderSide: BorderSide(color: context.pColorScheme.stroke),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Grid.l),
                  borderSide: BorderSide(color: context.pColorScheme.stroke),
                ),
                suffixIcon: _textEditingController.text.isNotEmpty
                    ? SendMessageButton(
                        tickets: widget.ticket,
                        textController: _textEditingController,
                        files: _files,
                        ticketBloc: widget.ticketBloc,
                        onSendMessage: (files) => setState(() => _files = null),
                      )
                    : null,
                prefixIcon: FilePickerButton(
                  fromActiveTicket: true,
                  hasFiles: _files != null,
                  onPickFile: () => _pickFiles(context, FileType.media),
                  onPickImage: () => _pickFiles(context, FileType.any),
                ),
                hintText: L10n.tr('reply'),
                hintStyle: context.pAppStyle.labelReg14textPrimary,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_state.dart';
import 'package:piapiri_v2/app/ticket/model/get_ticket_messages_model.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:url_launcher/url_launcher.dart';

//chat kısmının mesajı tasarımı
class TicketChatBubble extends StatelessWidget {
  final GetTicketMessagesModel message;
  final TicketState state;

  const TicketChatBubble({
    super.key,
    required this.message,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: Grid.s + Grid.xs,
        left: message.operatorId != null ? 0 : Grid.xl,
        right: message.operatorId != null ? Grid.xl : 0,
      ),
      child: Align(
        alignment: message.operatorId != null ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(Grid.m),
              topRight: const Radius.circular(Grid.m),
              bottomLeft: Radius.circular(
                message.operatorId != null ? Grid.xxs : Grid.m,
              ),
              bottomRight: Radius.circular(
                message.operatorId != null ? Grid.m : Grid.xxs,
              ),
            ),
            color: message.operatorId != null ? context.pColorScheme.card : context.pColorScheme.secondary,
          ),
          padding: const EdgeInsets.all(Grid.m),
          child: Column(
            crossAxisAlignment: message.operatorId != null ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              if (message.attachments != null &&
                  message.attachments!.isNotEmpty &&
                  message.attachments![0] != null &&
                  message.attachments![0] != '')
                IconButton(
                  iconSize: 50,
                  splashRadius: 1,
                  onPressed: () async {
                    final Uri uri = Uri.parse(message.attachments![0]);
                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                  },
                  icon: Container(
                    height: Grid.xl * 3,
                    width: Grid.xl * 2,
                    color: context.pColorScheme.card.shade100,
                    child: Center(
                      child: SvgPicture.asset(
                        ImagesPath.attach,
                        width: Grid.xl,
                        colorFilter: ColorFilter.mode(
                          message.operatorId != null ? context.pColorScheme.textPrimary : context.pColorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              Text(
                message.content ?? '',
                textAlign: message.operatorId != null ? TextAlign.left : TextAlign.right,
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m - Grid.xxs,
                  color: message.operatorId != null ? context.pColorScheme.textPrimary : context.pColorScheme.primary,
                ),
              ),
              const SizedBox(height: Grid.s),
              Text(
                DateTimeUtils.dateAndTimeFromDate(message.created!, splitter: ','),
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m - Grid.xxs,
                  color: message.operatorId != null ? context.pColorScheme.textPrimary : context.pColorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

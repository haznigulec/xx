import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/ticket/model/get_tickets_model.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

//ticket listesi tile
class SituationTile extends StatelessWidget {
  final GetTicketsModel tickets;
  final String title;

  const SituationTile({
    super.key,
    required this.tickets,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      focusColor: context.pColorScheme.transparent,
      onTap: () {
        router.push(
          ActiveTicketRoute(
            title: title,
            ticket: tickets,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.m,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Grid.xs,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    tickets.subject ?? '',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: context.pAppStyle.labelReg16textPrimary,
                  ),
                ),
                SvgPicture.asset(
                  ImagesPath.chevron_right,
                  height: 15,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            Text(
              DateTimeUtils.dateFormat(
                DateTime.parse(tickets.created!),
              ),
              style: context.pAppStyle.labelMed12textSecondary,
              maxLines: 1,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  TicketStatusHelper.toImage(
                    tickets.ticketStatus!,
                  ),
                  height: 15,
                  colorFilter: ColorFilter.mode(
                    TicketStatusHelper.toColor(
                      tickets.ticketStatus!,
                    ),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                Text(
                  L10n.tr(
                    TicketStatusHelper.toText(
                      tickets.ticketStatus!,
                    ),
                  ),
                  style: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: Grid.m - Grid.xxs,
                    color: TicketStatusHelper.toColor(
                      tickets.ticketStatus!,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

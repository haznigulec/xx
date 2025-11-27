import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_bloc.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_event.dart';
import 'package:piapiri_v2/app/ticket/model/get_tickets_model.dart';
import 'package:piapiri_v2/app/ticket/widget/ticker_rating_widget.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TicketInfoWidget extends StatelessWidget {
  final GetTicketsModel ticket;
  final String content;
  const TicketInfoWidget({
    required this.ticket,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: Grid.m + Grid.xs,
        ),
        _infoTextWidget(
          context,
          leadingText: L10n.tr('kullanici'),
          trailingText: ticket.customerExtId ?? '',
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.l / 2,
          ),
          child: PDivider(),
        ),
        _infoTextWidget(
          context,
          leadingText: L10n.tr('konu'),
          trailingText: ticket.subject ?? '',
        ),
        const SizedBox(
          height: Grid.l / 2,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 23,
            child: TicketStatusHelper.toValue(TicketStatus.closed) != ticket.ticketStatus
                ? PButton(
                    text: L10n.tr('close_ticket'),
                    sizeType: PButtonSize.small,
                    onPressed: () {
                      PBottomSheet.showError(
                        context,
                        content: L10n.tr('gorusmeyi_sonlandirmak_istedigine_emin_misin'),
                        showFilledButton: true,
                        showOutlinedButton: true,
                        filledButtonText: L10n.tr('onayla'),
                        outlinedButtonText: L10n.tr('vazgec'),
                        onFilledButtonPressed: () {
                          ratingBottomSheet(context, ticket);
                          getIt<TicketBloc>().add(
                            ChangeTicketStatusEvent(
                              content: content,
                              ticketId: ticket.id!,
                              ticketStatus: 30,
                            ),
                          );
                        },
                        onOutlinedButtonPressed: () {
                          router.maybePop();
                        },
                      );
                    },
                  )
                : POutlinedButton(
                    text: L10n.tr('closed_ticket'),
                    variant: PButtonVariant.ghost,
                  ),
          ),
        ),
        const SizedBox(
          height: Grid.l / 2,
        ),
        const PDivider(),
      ],
    );
  }

  Widget _infoTextWidget(
    BuildContext context, {
    required String leadingText,
    required String trailingText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leadingText,
          overflow: TextOverflow.ellipsis,
          style: context.pAppStyle.labelReg14textSecondary,
        ),
        const SizedBox(
          width: Grid.m,
        ),
        Expanded(
          child: Text(
            trailingText,
            maxLines: 2,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: context.pAppStyle.labelReg14textPrimary,
          ),
        ),
      ],
    );
  }
}

ratingBottomSheet(context, GetTicketsModel ticket) {
  int star = 1;

  PBottomSheet.show(
    context,
    isDismissible: false,
    enableDrag: false,
    child: TicketRatingWidget(
      ticket: ticket,
      onRatingSelected: (rating) {
        star = rating.toInt();
      },
    ),
    positiveAction: PBottomSheetAction(
      text: L10n.tr('tamam'),
      action: () {
        getIt<TicketBloc>().add(
          TicketEvaluateEvent(
            ticketId: ticket.id!,
            star: star,
          ),
        );
        router.pushAndPopUntil(
          TicketRoute(
            title: L10n.tr('hata_bildir_v2'),
          ),
          predicate: (route) => route.settings.name == ContactUsRoute.name,
        );
      },
    ),
  );
}

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_bloc.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_event.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_state.dart';
import 'package:piapiri_v2/app/ticket/model/get_ticket_messages_model.dart';
import 'package:piapiri_v2/app/ticket/model/get_tickets_model.dart';
import 'package:piapiri_v2/app/ticket/widget/active_ticket_textfield.dart';
import 'package:piapiri_v2/app/ticket/widget/ticket_chat_bubble.dart';
import 'package:piapiri_v2/app/ticket/widget/ticket_info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

//Ticketların chat ekranı
@RoutePage()
class ActiveTicketPage extends StatefulWidget {
  final String title;
  final GetTicketsModel ticket;
  const ActiveTicketPage({
    super.key,
    required this.title,
    required this.ticket,
  });

  @override
  State<ActiveTicketPage> createState() => _ActiveTicketPageState();
}

class _ActiveTicketPageState extends State<ActiveTicketPage> {
  late TicketBloc _ticketBloc;
  @override
  void initState() {
    _ticketBloc = getIt<TicketBloc>();
    _ticketBloc.add(
      GetTicketMessagesEvent(
        ticketId: widget.ticket.id!,
      ),
    );
    super.initState();
  }

  bool _hasFile = false;
  List<GetTicketMessagesModel> message = <GetTicketMessagesModel>[];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(
    BuildContext context,
  ) {
    return PBlocBuilder<TicketBloc, TicketState>(
      bloc: _ticketBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: PInnerAppBar(
            title: widget.title,
          ),
          bottomSheet: Container(
            color: context.pColorScheme.backgroundColor,
            child: TicketStatusHelper.toValue(TicketStatus.closed) != widget.ticket.ticketStatus
                ? ActiveTicketTextField(
                    ticket: widget.ticket,
                    ticketBloc: _ticketBloc,
                    onHasFiles: (hasFile) => setState(
                      () {
                        _hasFile = hasFile;
                      },
                    ),
                  )
                : const SizedBox(),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: Column(
                children: [
                  TicketInfoWidget(
                    ticket: widget.ticket,
                    content: _textEditingController.text,
                  ),
                  if (state.isFailed || state.ticketMessages.isEmpty) ...[
                    Expanded(
                      child: NoDataWidget(
                        message: L10n.tr('no_data'),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.ticketMessages.length,
                        padding: const EdgeInsets.only(
                          top: Grid.m,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return TicketChatBubble(
                            message: state.ticketMessages[index],
                            state: state,
                          );
                        },
                      ),
                    ),
                  ],
                  SizedBox(
                    height: _hasFile ? Grid.xxl * 2 : Grid.l * 3,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

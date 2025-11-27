import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_bloc.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_event.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_state.dart';
import 'package:piapiri_v2/app/ticket/widget/no_ticket_widget.dart';
import 'package:piapiri_v2/app/ticket/widget/situation_tile.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class TicketPage extends StatefulWidget {
  final String title;
  const TicketPage({super.key, required this.title});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  int recordCount = 10;
  final ScrollController _scrollController = ScrollController();
  late TicketBloc _ticketBloc;
  late AuthBloc _authBloc;
  @override
  void initState() {
    _ticketBloc = getIt<TicketBloc>();
    _authBloc = getIt<AuthBloc>();
    if (_authBloc.state.isLoggedIn) {
      _ticketBloc.add(
        GetTicketsEvent(
          recordCount: recordCount.toString(),
          skipCount: '0',
        ),
      );
    }
    _scrollController.addListener(_scrollListener);
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
            persistentFooterButtons: state.tickets.isEmpty
                ? null
                : [
                    PButton(
                      text: L10n.tr('new_create_ticket'),
                      fillParentWidth: true,
                      onPressed: () => {
                        router.push(
                          CreateTicketRoute(
                            title: widget.title,
                          ),
                        ),
                      },
                    ),
                  ],
            body: !_authBloc.state.isLoggedIn
                ? CreateAccountWidget(
                    memberMessage: L10n.tr('create_account_ticket_alert'),
                    loginMessage: L10n.tr('login_ticket_alert'),
                    onLogin: () => router.push(
                      AuthRoute(
                        afterLoginAction: () async {
                          router.push(
                            TicketRoute(
                              title: L10n.tr('hata_bildir_v2'),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.m,
                    ),
                    child: SafeArea(
                      child: state.isFailed || state.tickets.isEmpty
                          ? NoTicketWidget(
                              onCreateTicket: () {
                                router.push(
                                  CreateTicketRoute(
                                    title: widget.title,
                                  ),
                                );
                              },
                            )
                          : ListView.separated(
                              itemCount: state.tickets.length,
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => const PDivider(),
                              itemBuilder: (context, index) => SituationTile(
                                tickets: state.tickets[index],
                                title: widget.title,
                              ),
                            ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        recordCount += 10;
        _ticketBloc.add(
          GetTicketsEvent(
            recordCount: recordCount.toString(),
            skipCount: '0',
          ),
        );
      });
    }
  }
}

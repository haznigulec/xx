import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/agreements/bloc/agreements_bloc.dart';
import 'package:piapiri_v2/app/agreements/bloc/agreements_event.dart';
import 'package:piapiri_v2/app/agreements/bloc/agreements_state.dart';
import 'package:piapiri_v2/app/agreements/pages/agreements_card.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/agreements_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

//mutabakatlar
@RoutePage()
class AgreementsPage extends StatefulWidget {
  final String title;
  const AgreementsPage({
    super.key,
    required this.title,
  });

  @override
  State<AgreementsPage> createState() => _AgreementsPageState();
}

class _AgreementsPageState extends State<AgreementsPage> {
  late AgreementsBloc _agreementsBloc;
  late AuthBloc _authBloc;
  @override
  void initState() {
    _agreementsBloc = getIt<AgreementsBloc>();
    _authBloc = getIt<AuthBloc>();
    _agreementsBloc.add(
      GetAgreementsEvent(
        date: DateTimeUtils.serverDate(
          DateTime.now(),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: widget.title,
      ),
      body: !_authBloc.state.isLoggedIn
          ? CreateAccountWidget(
              memberMessage: L10n.tr('create_account_agreements_alert'),
              loginMessage: L10n.tr('login_agreements_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(
                      AgreementsRoute(
                        title: widget.title,
                      ),
                    );
                  },
                ),
              ),
            )
          : SafeArea(
              child: PBlocBuilder<AgreementsBloc, AgreementsState>(
                bloc: _agreementsBloc,
                builder: (context, state) {
                  if (state.isLoading) {
                    return const PLoading();
                  }
                  if (state.agreementsList.isEmpty) {
                    NoDataWidget(
                      message: L10n.tr('no_data'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.m,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: Grid.s,
                        ),
                        _list(
                          state.agreementsList,
                        ),
                        const SizedBox(
                          height: Grid.m + Grid.xs,
                        ),
                        PInfoWidget(
                          infoText: (state.agreementsList.length - 1) == 0
                              ? L10n.tr('agreement_info_v2')
                              : L10n.tr('waiting_agreement_v2'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _list(List<AgreementsModel> reconciliation) {
    return Flexible(
      child: ListView.separated(
        itemCount: reconciliation.length,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => const PDivider(
          padding: EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
        ),
        itemBuilder: (context, index) {
          return AggrementsCard(
            reconciliation: reconciliation[index],
            onTap: () async {
              String overallDate = '';
              bool isOutOfPeriod = true;
              //Günlük mutabakat
              if (index == 0) {
                overallDate = DateTimeUtils.serverDate(DateTime.now().subtract(const Duration(days: 1)));
              } else {
                DateTime now = getIt<TimeBloc>().state.mxTime?.timestamp != null
                    ? DateTime.fromMicrosecondsSinceEpoch(getIt<TimeBloc>().state.mxTime!.timestamp.toInt())
                    : DateTime.now();
                DateTime startDate = DateTime.parse(reconciliation[index].periodStartDate.toString());
                DateTime endDate = DateTime.parse(reconciliation[index].periodEndDate.toString());

                if (now.isAfter(startDate) && now.isBefore(endDate)) {
                  overallDate = DateTimeUtils.serverDate(DateTime.now().subtract(const Duration(days: 1)));
                  isOutOfPeriod = false;
                } else {
                  overallDate =
                      DateTimeUtils.serverDate(DateTime.parse(reconciliation[index].periodEndDate.toString()));
                  isOutOfPeriod = false;
                }
              }

              router.push(
                MyAggrementsFormRoute(
                  reconcilition: reconciliation[index],
                  overallDate: overallDate,
                  isOutOfPeriod: isOutOfPeriod,
                  onAggreement: () {
                    reconciliation.clear();
                    getIt<AgreementsBloc>().add(
                      GetAgreementsEvent(
                        date: DateTimeUtils.serverDate(DateTime.now()),
                        callback: (_, __) {},
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

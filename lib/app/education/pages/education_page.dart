import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/education/bloc/education_bloc.dart';
import 'package:piapiri_v2/app/education/bloc/education_event.dart';
import 'package:piapiri_v2/app/education/bloc/education_state.dart';
import 'package:piapiri_v2/app/education/widgets/education_card.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/education_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class EducationPage extends StatefulWidget {
  final String title;
  const EducationPage({
    super.key,
    required this.title,
  });

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  late EducationBloc _educationBloc;
  late AuthBloc _authBloc;
  @override
  void initState() {
    _educationBloc = getIt<EducationBloc>();
    _authBloc = getIt<AuthBloc>();
    if (_authBloc.state.isLoggedIn) {
      _educationBloc.add(
        GetEducationEvent(),
      );
    }
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
              memberMessage: L10n.tr('create_account_education_alert'),
              loginMessage: L10n.tr('login_education_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(
                      EducationRoute(
                        title: widget.title,
                      ),
                    );
                  },
                ),
              ),
            )
          : PBlocBuilder<EducationBloc, EducationState>(
              bloc: _educationBloc,
              builder: (context, state) {
                if (state.isInitial || state.isLoading) {
                  return const PLoading();
                }

                if (state.isFailed || state.educationList.isEmpty) {
                  return NoDataWidget(
                    message: L10n.tr('no_news_found'),
                  );
                }

                return SafeArea(
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: state.educationList.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                      left: Grid.m,
                      right: Grid.m,
                      top: Grid.m,
                      bottom: Grid.xxl,
                    ),
                    separatorBuilder: (context, index) => const PDivider(
                      padding: EdgeInsets.symmetric(
                        vertical: Grid.m,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      EducationListModel educationList = state.educationList[index];

                      return EducationCard(
                        educationList: educationList,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

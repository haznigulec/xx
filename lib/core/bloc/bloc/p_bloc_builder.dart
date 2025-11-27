import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class PBlocBuilder<B extends PBloc<S>, S extends PState> extends StatelessWidget {
  final B bloc;
  final BlocWidgetBuilder<S> builder;
  final BlocBuilderCondition<S>? buildWhen;
  final BlocWidgetBuilder<S>? errorBuilder;

  const PBlocBuilder({
    super.key,
    required this.builder,
    this.errorBuilder,
    required this.bloc,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: bloc,
      buildWhen: buildWhen,
      builder: (context, state) {
        if (state.error?.showErrorWidget == true &&
            state.error?.message != 'Timeout' &&
            !getIt<AppInfoBloc>().state.hasErrorAlert) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Utils().showErrorMessage(
              context: context,
              errorCode: state.error?.errorCode ?? '',
              text: state.error?.message ?? '',
              action: () {
                bloc.add(const ResetError());
              },
            );
          });
        }

        return builder(context, state);
      },
    );
  }
}

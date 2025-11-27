import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';

class PBlocListener<B extends PBloc<S>, S extends PState> extends StatelessWidget {
  final B? bloc;
  final BlocWidgetListener<S> listener;
  final BlocBuilderCondition<S>? listenWhen;
  final Widget? child;

  const PBlocListener({
    super.key,
    required this.listener,
    this.bloc,
    this.listenWhen,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      bloc: bloc,
      listenWhen: listenWhen,
      key: key,
      listener: listener,
      child: child,
    );
  }
}

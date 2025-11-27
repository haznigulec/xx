import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

@immutable
abstract class PState extends Equatable {
  final PageState type;
  final PBlocError? error;

  const PState({
    required this.type,
    this.error,
  });

  bool get isFailed => type == PageState.failed;

  bool get isNotFailed => !isFailed;

  bool get isLoading => type == PageState.loading;

  bool get isNotLoading => !isLoading;

  bool get isSuccess => type == PageState.success;

  bool get isUpdated => type == PageState.updated;

  bool get isSubmitting => type == PageState.submitting;

  bool get isNotSubmitting => !isSubmitting;

  bool get isNotSuccess => !isSuccess;

  bool get isInitial => type == PageState.initial;

  bool get isReadyToNavigate => type == PageState.readyToNavigate;

  bool get isNotReadyToNavigate => !isReadyToNavigate;

  bool get isFetching => type == PageState.fetching;

  bool get isNotFetching => !isFetching;

  bool get isDeleting => type == PageState.deleting;

  PState copyWith({
    PageState? type,
    PBlocError? error,
  });

  @override
  List<Object?> get props => [type];
}

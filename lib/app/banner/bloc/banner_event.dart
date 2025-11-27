import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class BannerEvent extends PEvent {}

class GetBannersEvent extends BannerEvent {}

class GetCachedBannersEvent extends BannerEvent {}

class GetMemberBannersEvent extends BannerEvent {
  final String phoneNumber;

  GetMemberBannersEvent(this.phoneNumber);
}

class SetExpandedBannersEvent extends BannerEvent {
  final bool isExpanded;

  SetExpandedBannersEvent({
    required this.isExpanded,
  });
}

class GetBannerIsExpandedEvent extends BannerEvent {
  final Function(bool isExpanded) onIsExpanded;

  GetBannerIsExpandedEvent({
    required this.onIsExpanded,
  });
}

class ResetBannersEvent extends BannerEvent {}

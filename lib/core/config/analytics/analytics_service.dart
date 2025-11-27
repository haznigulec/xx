import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter_insider/flutter_insider.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
// import 'package:piapiri_v2/core/config/router/route_descriptions.dart';
// import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/services/token_service.dart';

class AnalyticsService implements Analytics {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> track(
    String event, {
    Map<String, dynamic>? properties,
    List<String> taxonomy = const [],
  }) async {
    if (_isAnalyticsDisabled() || event.isEmpty) {
      return;
    }

    properties ??= <String, dynamic>{};

    final propertiesCopy = <String, dynamic>{};
    propertiesCopy['app_launch_id'] = getIt<AppInfo>().appLaunchId;
    propertiesCopy['token'] = getIt<TokenService>().getToken();

    for (final entry in properties.entries) {
      final value = entry.value;

      if (value != null) {
        if (value is num || value is String || value is List<String>) {
          propertiesCopy[entry.key] = value;
        } else {
          final convertedValue = value.toString();
          propertiesCopy[entry.key] = convertedValue;
        }
      }
    }
    String? adjustToken = AnalyticsEvents().adjustEvents[event];
    if (adjustToken != null) {
      Adjust.trackEvent(AdjustEvent(adjustToken));
    }
    await _trackInsider(
      event,
      propertiesCopy,
      taxonomy,
    );
    talker.info(
      '$event $propertiesCopy',
      'ANALYTIC EVENT SENT',
    );
    try {
      String firebaseName = event.toLowerCase().replaceAll(' ', '_');
      if (firebaseName.length > 40) {
        firebaseName = firebaseName.substring(0, 40);
      }
    } catch (e) {
      talker.critical(e.toString());
    }
  }

  @override
  Future<void> screen(
    String screenName, {
    Map<String, dynamic>? properties,
  }) async {
    if (_isAnalyticsDisabled() || screenName.isEmpty) {
      return;
    }

    String fixedScreenName = screenName;

    if (!screenName.startsWith('/')) {
      fixedScreenName = screenName;
    }

    properties ??= <String, dynamic>{};
    properties['app_launch_id'] = getIt<AppInfo>().appLaunchId;
    properties['token'] = getIt<TokenService>().getToken();

    talker.info(
      '$fixedScreenName $properties',
      'SCREEN EVENT SENT',
    );
  }

  @override
  Future<void> setFirebaseUserProperties({
    required String customerId,
    required String deviceId,
  }) async {
    await setFirebaseUserProperty('customerId', customerId);
    // await FirebaseCrashlytics.instance.setCustomKey('deviceId', deviceId);
    // await FirebaseCrashlytics.instance.setCustomKey('customerId', customerId);
    // await FirebaseCrashlytics.instance.setCustomKey(
    //   'breadcrumbs',
    //   router.routeNames.isNotEmpty ? router.routeNames.join(',') : '',
    // );
    talker.info(
      '----------------------\n'
      'Firebase Identification \n'
      'CustomerId: ($customerId) \n'
      'DeviceId:   ($deviceId) \n'
      'Category: firebase \n'
      'Method: SET USER PROPERTIES \n'
      '----------------------',
    );
  }

  @override
  Future<void> setFirebaseUserProperty(String name, String? value) async {
    // await FirebaseCrashlytics.instance.setUserIdentifier('$name: ${value ?? ''}');
  }

  bool _isAnalyticsDisabled() {
    // return appFlavor != 'prod';
    return false;
  }

  Future<void> _trackInsider(
    String analyticsEvent,
    Map<String, dynamic> properties,
    List<String> taxonomy,
  ) async {
    // List<String> taxonomyArray = _prepareTaxonomy();
    // log('taxonomyArray: $taxonomyArray');
    // log('taxonomyArray: $taxonomy -  analyticsEvent: $analyticsEvent');

    switch (analyticsEvent) {
      case AnalyticsEvents.homePageView:
        FlutterInsider.Instance.visitHomePage();
        break;
      case AnalyticsEvents.videoCallSignUpClick:
        FlutterInsider.Instance.signUpConfirmation();
        break;
      default:
        if (properties['product_id'] != null) {
          FlutterInsider.Instance.tagEvent(analyticsEvent)
              .addParameterWithString('name', properties['name'])
              // .addParameterWithArray('taxonomy', taxonomyArray)
              .addParameterWithArray('taxonomy', taxonomy)
              .addParameterWithDouble('price', properties['price'] ?? 0.0)
              .addParameterWithString('product_id', properties['product_id'])
              .addParameterWithString('currency', properties['currency'] ?? 'TRY')
              .build();
        } else {
          // FlutterInsider.Instance.tagEvent(analyticsEvent).addParameterWithArray('taxonomy', taxonomyArray).build();
          FlutterInsider.Instance.tagEvent(analyticsEvent).addParameterWithArray('taxonomy', taxonomy).build();
        }
        break;
    }
  }

  // List<String> _prepareTaxonomy() {
  //   List<String> taxonomyArray =
  //       router.routeNames.isNotEmpty ? router.routeNames.map<String>((e) => routeDescriptions[e] ?? '').toList() : [];
  //   return taxonomyArray;
  // }
}

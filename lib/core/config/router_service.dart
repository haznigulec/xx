import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';

class PRouter {
  static final StackRouter router = AutoRouter.of(NavigatorKeys.navigatorKey.currentContext!);
  final List<String> _routeNames = [];

  List<String> get routeNames => _routeNames;

  Future<void> replaceAll(List<PageRouteInfo> routes) {
    _routeNames.clear();
    _routeNames.addAll(routes.map((e) => e.routeName));
    return router.replaceAll(routes);
  }

  Future<T?> push<T extends Object?>(PageRouteInfo<dynamic> route, {void Function(NavigationFailure)? onFailure}) {
    _routeNames.add(route.routeName);
    return router.push(route, onFailure: onFailure);
  }

  Future<bool> maybePop<T extends Object?>([T? result]) {
    int indexOfCurrentPage = _routeNames.indexOf(router.current.name);
    if (indexOfCurrentPage >= 0) {
      _routeNames.removeRange(indexOfCurrentPage, _routeNames.length);
    }
    return router.maybePop(result);
  }

  void pop<T extends Object?>(BuildContext context, [T? result]) {
    int indexOfCurrentPage = _routeNames.indexOf(router.current.name);
    if (indexOfCurrentPage >= 0) {
      _routeNames.removeRange(indexOfCurrentPage, _routeNames.length);
    }
    return Navigator.of(context).pop(result);
  }

  Future<T?> popAndPush<T extends Object?, TO extends Object?>(
    PageRouteInfo<dynamic> route, {
    TO? result,
    void Function(NavigationFailure)? onFailure,
  }) {
    final int indexOfCurrentPage = _routeNames.indexOf(router.current.name);
    if (indexOfCurrentPage >= 0) {
      _routeNames.removeRange(indexOfCurrentPage, _routeNames.length);
    }
    _routeNames.add(route.routeName);
    return router.popAndPush(route, result: result, onFailure: onFailure);
  }

  Future<bool> popWolt<T extends Object?>([T? result]) {
    if (_routeNames.isNotEmpty) {
      _routeNames.removeLast();
    }
    return router.maybePop(result);
  }

  void popCurrentRouteNameOnly() {
    if (_routeNames.isNotEmpty) {
      int indexOfCurrentPage = _routeNames.indexOf(router.current.name);
      if (indexOfCurrentPage == _routeNames.length - 1) {
        _routeNames.removeLast();
      } else if (indexOfCurrentPage >= 0) {
        _routeNames.removeRange(indexOfCurrentPage, _routeNames.length);
      }
    }
  }

  void popAndPushTabBarRouteName(String actualTab, String newTab) {
    if (_routeNames.isEmpty) {
      _routeNames.add(newTab);
      return;
    }
    int indexOfPage = _routeNames.indexOf(actualTab);
    if (indexOfPage == _routeNames.length - 1) {
      _routeNames.removeLast();
    } else if (indexOfPage > 0) {
      _routeNames.removeRange(indexOfPage, _routeNames.length);
    }
    _routeNames.add(newTab);
  }

  Future<T?> replace<T extends Object?>(
    PageRouteInfo route, {
    OnNavigationFailure? onFailure,
  }) {
    int indexOfCurrentPage = _routeNames.indexOf(router.current.name);
    if (indexOfCurrentPage >= 0) _routeNames.removeRange(indexOfCurrentPage, _routeNames.length);
    _routeNames.add(route.routeName);
    return router.replace(route, onFailure: onFailure);
  }

  Future<T?> pushAndPopUntil<T extends Object?>(
    PageRouteInfo route, {
    required RoutePredicate predicate,
    bool scopedPopUntil = true,
    OnNavigationFailure? onFailure,
  }) {
    return router.pushAndPopUntil(
      route,
      predicate: predicate,
      scopedPopUntil: scopedPopUntil,
      onFailure: onFailure,
    );
  }

  void popUntilRouteWithName(String name, {bool scoped = true}) {
    while (_routeNames.isNotEmpty && _routeNames.last != name) {
      _routeNames.removeLast();
    }
    router.popUntilRouteWithName(name, scoped: scoped);
  }

  void popUntilWithMultipleRouteNames(List<String> names, {bool scoped = true}) {
    while (_routeNames.isNotEmpty && names.contains(_routeNames.last) != false) {
      _routeNames.removeLast();
    }
    router.popUntil((route) => names.contains(route.settings.name), scoped: scoped);
  }

  void popUntilRoot() {
    if (_routeNames.length <= 2) {
      _routeNames.clear();
    } else {
      _routeNames.removeRange(2, _routeNames.length);
    }
    router.popUntilRouteWithName(DashboardRoute.name);
  }

  void popTimes(int times) {
    if (_routeNames.isNotEmpty && times > 0) {
      for (int i = 0; i < times; i++) {
        _routeNames.removeLast();
        router.maybePop();
      }
    }
  }

  void replaceTab(String tabName) {
    if (_routeNames.isNotEmpty) _routeNames.removeLast();
    addTab(tabName);
  }

  void addTab(String tabName) {
    if (_routeNames.isNotEmpty && _routeNames.last != tabName) {
      _routeNames.add(tabName);
    }
  }

  void removeTab(String tabName) {
    _routeNames.remove(tabName);
  }

//route dizininde verilen page var mı?
  bool isPageInStack(String routeName) {
    return _routeNames.contains(routeName);
  }
}

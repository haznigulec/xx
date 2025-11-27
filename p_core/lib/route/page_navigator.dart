import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:p_core/route/router_extensions.dart';

class PageNavigator {
  static BuildContext? get globalContext => NavigatorKeys.navigatorKey.currentState?.overlay?.context;

  static StackRouter get routerOfGlobalContext {
    return AutoRouter.of(globalContext!);
  }

  static BuildContext? get currentContext => NavigatorKeys.navigatorKey.currentContext;

  static StackRouter get routerOfCurrentContext {
    return AutoRouter.of(currentContext!);
  }

  static StackRouter? get currentRouter {
    final RoutingController? router = globalContext?.router.topMostRouter();
    if (router is StackRouter) {
      return router;
    } else {
      return router?.root;
    }
  }

  static bool? get isRoot => currentRouter?.isRoot;

  static Future<T?> push<T extends Object?>(PageRouteInfo route, {bool insideTab = false}) {
    if (insideTab == true) {
      return routerOfCurrentContext.push(route);
    } else {
      return routerOfGlobalContext.push(route);
    }
  }

  static Future<T?>? pushNamed<T extends Object?>(String route, {bool insideTab = false}) async {
    List<RouteMatch>? matches = routerOfGlobalContext.matcher.match(route);
    if (matches == null || matches.isEmpty) {
      final routeNameWithRouteSuffix = route.addRouteSuffixIfNotExist();
      matches = routerOfGlobalContext.matcher.match(routeNameWithRouteSuffix);
    }

    if (matches?.isNotEmpty == true) {
      final RouteMatch match = matches!.first;
      if (insideTab == true) {
        return currentRouter?.push(match.toPageRouteInfo());
      } else {
        return push(match.toPageRouteInfo());
      }
    }
    return null;
  }

  static Future<void>? navigateNamed<T extends Object?>(String route) async {
    List<RouteMatch>? matches = routerOfGlobalContext.matcher.match(route);
    if (matches == null || matches.isEmpty) {
      final routeNameWithRouteSuffix = route.addRouteSuffixIfNotExist();
      matches = routerOfGlobalContext.matcher.match(routeNameWithRouteSuffix);
    }

    if (matches?.isNotEmpty == true) {
      final RouteMatch match = matches!.first;
      if (routerOfGlobalContext.childControllers.isEmpty) {
        routerOfGlobalContext.navigateNamed(match.stringMatch);
      } else {
        push(match.toPageRouteInfo());
      }
    }
  }

  static Future<T?>? popAndPush<T extends Object?, TO extends Object>(
    PageRouteInfo route, {
    bool insideTab = false,
    TO? result,
  }) {
    if (insideTab == true) {
      return currentRouter?.popAndPush(route);
    } else {
      return routerOfGlobalContext.popAndPush(
        route,
        result: result,
      );
    }
  }

  static Future<T?>? pushReplacement<T extends Object?>(
    PageRouteInfo route, {
    bool insideTab = false,
  }) {
    if (insideTab == true) {
      return currentRouter?.replace(route);
    } else {
      return routerOfGlobalContext.replace(route);
    }
  }

  static Future<T?> pushAndRemoveUntil<T extends Object?>(PageRouteInfo route, PageRouteInfo anchorRoute) {
    routerOfGlobalContext.removeUntil((RouteData r) => r.name == anchorRoute.routeName);
    return push(route);
  }

  static Future<T?> pushAndPopUntil<T extends Object?>(PageRouteInfo route, PageRouteInfo targetRoute) {
    return routerOfGlobalContext.pushAndPopUntil(route, predicate: (route) => _checkRoute(route, targetRoute));
  }

  static Future<void> pushAsHome<T extends Object?>(PageRouteInfo route) {
    popUntilRoot();
    return replaceAll([route]);
  }

  static void pop<T extends Object?>([T? result]) {
    NavigatorKeys.navigatorKey.currentState?.pop(result);
  }

  static Future<bool>? popInside() {
    return currentRouter?.maybePop();
  }

  static void popUntil(PageRouteInfo anchorRoute) {
    routerOfGlobalContext.popUntil((Route<dynamic> route) => _checkRoute(route, anchorRoute));
  }

  static void popUntilInside(PageRouteInfo anchorRoute) {
    routerOfCurrentContext.popUntil((Route<dynamic> route) => _checkRoute(route, anchorRoute));
  }

  static void popUntilRoot() {
    routerOfGlobalContext.root.popUntilRoot();
  }

  static void popUntilRootInside() {
    routerOfCurrentContext.root.popUntilRoot();
  }

  static Future<void> replaceAll(List<PageRouteInfo> routes) {
    return routerOfGlobalContext.root.replaceAll(routes);
  }

  static void popToHome() {
    NavigatorKeys.navigatorKey.currentState?.popUntil((Route route) => route.isFirst);
  }

  static Future<bool>? maybePop<T extends Object>({BuildContext? context, T? result}) {
    if (context != null) {
      return Navigator.of(context).maybePop(result);
    } else {
      return NavigatorKeys.navigatorKey.currentState?.maybePop(result);
    }
  }

  static bool? canPop() {
    return NavigatorKeys.navigatorKey.currentState?.canPop();
  }

  static bool _checkRoute(Route route, PageRouteInfo anchorRoute) =>
      route.isFirst || route.settings.name == anchorRoute.routeName;

  static bool isPageActive(String routePath) {
    return routerOfGlobalContext.current.path == routePath;
  }

  static Future<dynamic> navigate(PageRouteInfo page) {
    return routerOfGlobalContext.navigate(page);
  }
}

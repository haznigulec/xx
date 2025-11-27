import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_event.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/cache_managers/symbol_icon_cache_manager.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/model/theme_enum.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  final Function? afterInitFunc;
  final bool isFirstLoginAfterInstall;
  final bool fromMemberOtp;
  const SplashPage({
    super.key,
    this.afterInitFunc,
    this.fromMemberOtp = false,
    this.isFirstLoginAfterInstall = false,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AppInfoBloc _appInfoBloc = getIt<AppInfoBloc>();
  final MatriksBloc _matriksBloc = getIt<MatriksBloc>();
  final LanguageBloc _languageBloc = getIt<LanguageBloc>();
  final double _logoHeight = 48.0;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  _initialize() async {
    await _onCheckClearSymbolIconCacheManager();
    final Completer<void> languageKeysCompleter = Completer<void>();
    final Completer<void> appjustinstalledCompleter = Completer<void>();
    _languageBloc.add(
      LanguageGetKeysEvent(
        onSuccess: () {
          languageKeysCompleter.complete();
        },
      ),
    );

    _appInfoBloc.add(
      CheckAppFirstOpenEvent(
        callBack: () {
          appjustinstalledCompleter.complete();
        },
      ),
    );
    await appjustinstalledCompleter.future;
    await languageKeysCompleter.future;
    _appInfoBloc.add(GetSplashStoriesEvent());
    _appInfoBloc.add(
      ReadHasMembershipEvent(
        callback: (membership, customerId) {
          if (!membership['status'] && (customerId == null || customerId.isEmpty)) {
            router.pushAndPopUntil(
              CreateAccountRoute(
                isFirstLaunch: true,
              ),
              predicate: (_) => false,
            );
          } else {
            _matriksBloc.add(
              MatriksGetDiscoEvent(
                callback: () {
                  _matriksBloc.add(
                    MatriksGetTopicsEvent(
                      callback: () async {
                        ///Matriks tarafinin kac tekil kullanici oldugunu anlayabilmesi icin delayed token almadan
                        ///devam eden senaryo icin delayed token ile bir subscription olsuturuyoruz
                        if (widget.isFirstLoginAfterInstall) {
                          final Completer<void> dummySubsCompleter = Completer<void>();
                          getIt<SymbolBloc>().add(
                            SubscribeDLDummyEvent(callback: () {
                              dummySubsCompleter.complete();
                            }),
                          );
                          try {
                            // En fazla 1.5 saniye bekle
                            await dummySubsCompleter.future.timeout(
                              const Duration(milliseconds: 2500),
                            );
                          } on TimeoutException {
                            // 1.5 saniye içinde callback dönmezse burası çalışır
                            debugPrint('Callback dönmedi, devam ediliyor...');
                          }
                        }
                        _appInfoBloc.add(
                          InitEvent(
                            onError: (error) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(error),
                              ));
                            },
                            onSuccess: (_) {
                              _appInfoBloc.add(
                                InvalidateCacheEvent(),
                              );
                              _appInfoBloc.add(
                                SetAppThemeEvent(
                                  appTheme: _appInfoBloc.state.appTheme,
                                ),
                              );
                              _appInfoBloc.add(
                                GetUpdatedRecords(
                                  callback: () {},
                                ),
                              );
                              if (widget.afterInitFunc != null) {
                                widget.afterInitFunc!();
                              } else if (widget.fromMemberOtp) {
                                router.pushAndPopUntil(
                                  DashboardRoute(
                                    key: ValueKey(
                                      '${DashboardRoute.name}-${DateTime.now().millisecondsSinceEpoch}',
                                    ),
                                  ),
                                  predicate: (_) => false,
                                );
                              } else {
                                router.pushAndPopUntil(
                                  AuthRoute(
                                    fromSplash: true,
                                  ),
                                  predicate: (_) => false,
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _onCheckClearSymbolIconCacheManager() async {
    try {
      String symbolIconKey = AppConfig.instance.isProd ? 'symbolIconCachedDate_prod' : 'symbolIconCachedDate_dev';
      final String remoteDateJson = remoteConfig.getValue(symbolIconKey).asString();

      if (remoteDateJson.isEmpty) return;

      final String remoteDateStr = jsonDecode(remoteDateJson);
      final DateTime? remoteCachedDateParsed = DateTime.tryParse(remoteDateStr);

      if (remoteCachedDateParsed == null) return;

      final remoteCachedDate = DateTime(
        remoteCachedDateParsed.year,
        remoteCachedDateParsed.month,
        remoteCachedDateParsed.day,
        remoteCachedDateParsed.hour,
        remoteCachedDateParsed.minute,
      );

      final String? strLocalDate = getIt<LocalStorage>().read(symbolIconKey);
      bool isUpdate = strLocalDate == null;

      if (!isUpdate) {
        final DateTime? localCachedDateParsed = DateTime.tryParse(strLocalDate);
        if (localCachedDateParsed == null) {
          isUpdate = true;
        } else {
          final localCachedDate = DateTime(
            localCachedDateParsed.year,
            localCachedDateParsed.month,
            localCachedDateParsed.day,
            localCachedDateParsed.hour,
            localCachedDateParsed.minute,
          );

          if (remoteCachedDate.isAfter(localCachedDate)) {
            isUpdate = true;
          }
        }
      }

      if (isUpdate) {
        getIt<LocalStorage>().write(symbolIconKey, remoteDateStr);
        await SymbolIconCacheManager().emptyCache();
      }
    } catch (error) {
      log('found an error in onCheckClearSymbolIconCacheManager : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        left: false,
        right: false,
        child: Center(
          child: PBlocBuilder<AppSettingsBloc, AppSettingsState>(
            bloc: getIt<AppSettingsBloc>(),
            builder: (context, appSettingsState) => Shimmer.fromColors(
              baseColor: context.pColorScheme.textPrimary,
              highlightColor: appSettingsState.generalSettings.theme == ThemeEnum.light
                  ? context.pColorScheme.textPrimary.shade200
                  : context.pColorScheme.textPrimary.shade800,
              child: SizedBox(
                width: pageWidth * 0.5,
                height: _logoHeight,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    ImagesPath.darkPiapiriLoginLogo,
                    color: Theme.of(context).hoverColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

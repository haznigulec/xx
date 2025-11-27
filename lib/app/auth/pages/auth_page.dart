import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/circle_progress_indicator.dart';
import 'package:piapiri_v2/common/widgets/selection_control/checkbox.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/agreements/bloc/agreements_bloc.dart';
import 'package:piapiri_v2/app/agreements/bloc/agreements_event.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_event.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_state.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_bloc.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_event.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_event.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/textfields/custom_keyboard_textfield_widget.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/bloc_locator.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/config/service_locator_manager.dart';
import 'package:piapiri_v2/core/model/agreements_model.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class AuthPage extends StatefulWidget {
  final bool didNotLogin;
  final bool? fromSplash;
  // Dashboard Route yalnızca AuthPage içerisinden yapılmalıdır.
  // Şuan yukarıki maddeden ötürü Check biometrik her zaman true oluyor bu parametre ile sayfaya taşınabilir.Mustafayla konuş.
  // içerisinde Dashboard Route yapılmamalıdır.
  final VoidCallback? afterLoginAction;
  final int? activeIndex;
  final MarketMenu? marketMenu;
  final int? marketIndex;

  const AuthPage({
    super.key,
    this.didNotLogin = false,
    this.fromSplash = false,
    this.afterLoginAction,
    this.activeIndex,
    this.marketMenu,
    this.marketIndex,
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _rememberUsername = false;
  final AuthBloc _authBloc = getIt<AuthBloc>();
  final ContractsBloc _contractsBloc = getIt<ContractsBloc>();
  final AgreementsBloc _agreementsBloc = getIt<AgreementsBloc>();
  final AppSettingsBloc _appSettingsBloc = getIt<AppSettingsBloc>();
  final QuickPortfolioBloc _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
  final GlobalAccountOnboardingBloc _globalOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();
  final MatriksBloc _matriksBloc = getIt<MatriksBloc>();
  bool isLoading = false;
  bool? hasConnection;

  @override
  void initState() {
    super.initState();

    if (getIt<LocalStorage>().read(LocalKeys.tcCustomerNo) != null) {
      _rememberUsername = true;
      _usernameController.text = getIt<LocalStorage>().read(LocalKeys.tcCustomerNo);
    }

    if (_appSettingsBloc.state.generalSettings.touchFaceId) {
      if (!_rememberUsername) {
        _loadUsernameFromSecureStorage();
      }
      _rememberUsername = true;
      if (!isLaunchedNotification) {
        _onBiometrikLogin();
      }
    }

    if (isLaunchedNotification) {
      isLaunchedNotification = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder(
      bloc: _authBloc,
      builder: (context, AuthState state) {
        return Scaffold(
          // resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: Stack(
                children: [
                  //login ekranına splashten gelmiyorsa veya müşteriyse dashboarda gidebileceği butonu gösteriyoruz
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Splash ekranından gelmiyorsa ve login varsa Carpı butonu var
                              // login varsa dashboarda gidiyor
                              // login yoksa sayfayı kapatıyor
                              // testi yapılmalı
                              if (!widget.fromSplash! || !widget.didNotLogin) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Grid.s,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      highlightColor: context.pColorScheme.transparent,
                                      focusColor: context.pColorScheme.transparent,
                                      splashColor: context.pColorScheme.transparent,
                                      hoverColor: context.pColorScheme.transparent,
                                      onTap: () {
                                        if (!widget.didNotLogin) {
                                          _setDashboardInitializer();
                                          router.replaceAll(
                                            [
                                              DashboardRoute(
                                                key: ValueKey(
                                                    '${DashboardRoute.name}-${DateTime.now().millisecondsSinceEpoch}'),
                                              ),
                                            ],
                                          );
                                        } else {
                                          router.maybePop();
                                        }
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: context.pColorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(
                                height: Grid.xl,
                              ),
                              Container(
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  ImagesPath.darkPiapiriLoginLogo,
                                  width: 140,
                                  color: context.pColorScheme.textPrimary,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                height: Grid.m + Grid.xs,
                              ),
                              CustomKeyboardTextfieldWidget(
                                focusNode: _usernameFocus,
                                controller: _usernameController,
                                textStyle: context.pAppStyle.labelMed18textPrimary,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  if (_usernameController.text.isNotEmpty) {
                                    FocusScope.of(context).requestFocus(_passwordFocus);
                                  } else {
                                    _usernameFocus.unfocus();
                                  }
                                },
                                showSeperator: false,
                                label: L10n.tr('tc_musteri_numarasi'),
                                labelStyle: context.pAppStyle.labelReg16textSecondary,
                                focusedLabelStyle: context.pAppStyle.labelMed12textSecondary,
                                hasTextControl: false,
                                enabledColor: context.pColorScheme.primary,
                                focusedColor: context.pColorScheme.textTeritary,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(11),
                                ],
                              ),
                              const SizedBox(
                                height: Grid.s,
                              ),
                              CustomKeyboardTextfieldWidget(
                                focusNode: _passwordFocus,
                                controller: _passwordController,
                                textStyle: context.pAppStyle.labelMed18textPrimary,
                                textInputAction: TextInputAction.done,
                                showSeperator: false,
                                isObscure: true,
                                label: L10n.tr('sifre'),
                                labelStyle: context.pAppStyle.labelReg16textSecondary,
                                focusedLabelStyle: context.pAppStyle.labelMed12textSecondary,
                                hasTextControl: false,
                                enabledColor: context.pColorScheme.primary,
                                focusedColor: context.pColorScheme.textTeritary,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onFieldSubmitted: (_) {
                                  if (_passwordController.text.isNotEmpty && _usernameController.text.isNotEmpty) {
                                    _onLogin();
                                  } else {
                                    _passwordFocus.unfocus();
                                  }
                                },
                              ),
                              const SizedBox(height: Grid.xl / 2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  PCheckbox(
                                    width: Grid.l,
                                    height: Grid.l,
                                    value: _rememberUsername,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          _rememberUsername = value!;
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    width: Grid.s,
                                  ),
                                  Text(
                                    L10n.tr('remember_me'),
                                    style: context.pAppStyle.labelReg14textPrimary,
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    highlightColor: context.pColorScheme.transparent,
                                    splashColor: context.pColorScheme.transparent,
                                    focusColor: context.pColorScheme.transparent,
                                    onTap: () => router.push(
                                      const ForgotPasswordRoute(),
                                    ),
                                    child: Text(
                                      L10n.tr('sifremi_unuttum'),
                                      style: context.pAppStyle.labelMed14textPrimary.copyWith(
                                        color: context.pColorScheme.primary,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      PButton(
                        text: L10n.tr('giris_yap'),
                        sizeType: PButtonSize.medium,
                        onPressed: () => _passwordController.text.isNotEmpty && _usernameController.text.isNotEmpty
                            ? _onLogin()
                            : _emptyAlert(),
                      ),
                      const SizedBox(height: Grid.m),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: L10n.tr('new_in_piapiri'),
                              style: context.pAppStyle.labelReg16textPrimary,
                            ),
                            TextSpan(
                              text: ' ${L10n.tr('hesap_ac')}',
                              style: context.pAppStyle.labelMed16textPrimary.copyWith(
                                color: context.pColorScheme.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await getIt<Analytics>().track(
                                    AnalyticsEvents.splashStartButtonClick,
                                  );
                                  getIt<Analytics>().track(
                                    AnalyticsEvents.videoCallSignUpClick,
                                    taxonomy: [
                                      InsiderEventEnum.createAccountPage.value,
                                    ],
                                  );
                                  getIt<EnquraBloc>().add(
                                    CheckActiveProcessEvent(
                                      callback: (isActive) {
                                        if (isActive) {
                                          router.push(EnquraRoute());
                                        } else {
                                          getIt<Analytics>().track(
                                            AnalyticsEvents.splashStartButtonClick,
                                          );
                                          router.push(
                                            EnquraRegisterRoute(
                                              isFirstLaunch: widget.didNotLogin,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                    ],
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: const PCircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadUsernameFromSecureStorage() async {
    final userName = await getIt<LocalStorage>().readSecure(LocalKeys.loginTcCustomerNo);
    if (userName?.isNotEmpty == true) {
      _usernameController.text = userName!;
    }
  }

  void _onLogin() async {
    if (!await InternetConnectionChecker().hasConnection) {
      return Utils().showConnectivityAlert(
        context: NavigatorKeys.navigatorKey.currentContext ?? context,
      );
    }

    setState(() {
      isLoading = true;
    });

    _authBloc.add(
      LogInEvent(
        username: _usernameController.text,
        password: _passwordController.text,
        willRemember: _rememberUsername,
        onSuccess: (customerId, newCustomerWelcomeScreen) async {
          setState(() {
            isLoading = false;
          });
          _appSettingsBloc.add(
            GetOrderSettingsEvent(
              onCallback: () {
                onSuccessfulLogin(customerId, newCustomerWelcomeScreen);
                getIt<NotificationsBloc>().add(
                  NotificationGetCategories(),
                );
                if (UserModel.instance.innerType != null && UserModel.instance.innerType != 'INSTITUTION') {
                  _contractsBloc.add(
                    GetCustomerAnswersEvent(
                      onSuccess: (customerResponse) {
                        if (customerResponse.riskLevel == '' || customerResponse.riskLevel == null) {
                          if (!newCustomerWelcomeScreen) {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) {
                                router.push(
                                  ContractsSurveyRoute(title: L10n.tr('uygunluk_testi')),
                                );
                              },
                            );
                          } else if (newCustomerWelcomeScreen && !openUygunlukTestiAfterWelcomeScreen) {
                            openUygunlukTestiAfterWelcomeScreen = true;
                          }
                        }
                      },
                    ),
                  );
                }
              },
            ),
          );
        },
        onChangedRequiredPassword: (customerId, changedRequiredPassword) {
          PBottomSheet.show(
            context,
            isDismissible: false,
            child: Column(
              children: [
                SvgPicture.asset(
                  ImagesPath.alert_circle,
                  width: 52,
                  height: 52,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                Text(
                  L10n.tr('change_password_for_security'),
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                PBlocBuilder<AuthBloc, AuthState>(
                    bloc: _authBloc,
                    builder: (context, state) {
                      return PButton(
                        text: L10n.tr('tamam'),
                        fillParentWidth: true,
                        onPressed: () {
                          router.push(
                            ChangePasswordRoute(
                              isChangePasswordRequired: changedRequiredPassword,
                              onSuccess: (isSuccess, message) {},
                            ),
                          );
                        },
                      );
                    }),
              ],
            ),
          );

          return;
        },
        onCheckOtp: (customerId, otpTimeout, newCustomerWelcomeScreen) {
          setState(() {
            isLoading = false;
          });

          router.push(
            CheckOtpRoute(
              customerExtId: customerId,
              otpDuration: otpTimeout,
              callOtpAfterClickButton: true,
              onSuccess: () {
                _appSettingsBloc.add(
                  GetOrderSettingsEvent(onCallback: () {
                    onSuccessfulLogin(customerId, newCustomerWelcomeScreen);
                    if (UserModel.instance.innerType != null && UserModel.instance.innerType != 'INSTITUTION') {
                      _contractsBloc.add(
                        GetCustomerAnswersEvent(
                          onSuccess: (customerResponse) {
                            if (customerResponse.riskLevel == '' || customerResponse.riskLevel == null) {
                              if (!newCustomerWelcomeScreen) {
                                WidgetsBinding.instance.addPostFrameCallback(
                                  (_) {
                                    router.push(
                                      ContractsSurveyRoute(title: L10n.tr('uygunluk_testi')),
                                    );
                                  },
                                );
                              } else if (newCustomerWelcomeScreen && !openUygunlukTestiAfterWelcomeScreen) {
                                openUygunlukTestiAfterWelcomeScreen = true;
                              }
                            }
                          },
                        ),
                      );
                    }
                  }),
                );
              },
            ),
          );
        },
        onError: (String message) {
          bool navigateToPage = message == 'EXPIRED_PASSWORD';
          setState(() {
            isLoading = false;
          });
          return message == 'LOGIN_BLOCKED_FROM_LOGIN_FAILED'
              ? PBottomSheet.showError(
                  context,
                  content: L10n.tr('login.error.$message'),
                  showFilledButton: true,
                  showOutlinedButton: true,
                  filledButtonText: L10n.tr('reset_password'),
                  onFilledButtonPressed: () => router.push(
                    const ForgotPasswordRoute(),
                  ),
                  outlinedButtonText: L10n.tr('later'),
                  onOutlinedButtonPressed: () => router.maybePop(),
                )
              : PBottomSheet.showError(
                  context,
                  content: L10n.tr('login.error.$message'),
                  filledButtonText: L10n.tr('tamam'),
                  showFilledButton: true,
                  onFilledButtonPressed: () {
                    if (navigateToPage) {
                      router.push(
                        ChangeExpiredPasswordRoute(
                          customerExtId: _usernameController.text,
                        ),
                      );
                    } else {
                      router.maybePop();
                    }
                  },
                );
        },
      ),
    );
  }

  _emptyAlert() {
    return PBottomSheet.showError(
      context,
      content: L10n.tr('lutfen_tum_alanlari_doldurunuz'),
    );
  }

  _onBiometrikLogin() async {
    if (!await InternetConnectionChecker().hasConnection) {
      return Utils().showConnectivityAlert(
        context: NavigatorKeys.navigatorKey.currentContext ?? context,
      );
    }

    setState(() {
      isLoading = true;
    });
    try {
      _authBloc.add(
        BiometricLoginEvent(
          onSuccess: () async {
            _authBloc.add(
              LogInEvent(
                username: await getIt<LocalStorage>().readSecure(LocalKeys.loginTcCustomerNo) ??
                    getIt<LocalStorage>().read(LocalKeys.loginTcCustomerNo),
                password: await getIt<LocalStorage>().readSecure(LocalKeys.loginPassword) ??
                    getIt<LocalStorage>().read(LocalKeys.loginPassword),
                willRemember: _rememberUsername,
                biometricData: '${getIt<AppInfo>().deviceId};${DateTime.now().toString()}',
                onSuccess: (customerId, newCustomerWelcomeScreen) async {
                  getIt<Analytics>().track(AnalyticsEvents.login);
                  _appSettingsBloc.add(
                    GetOrderSettingsEvent(
                      onCallback: () {
                        onSuccessfulLogin(customerId, newCustomerWelcomeScreen);
                        getIt<NotificationsBloc>().add(
                          NotificationGetCategories(),
                        );
                      },
                    ),
                  );
                },
                onCheckOtp: (customerId, otpTimeout, newCustomerWelcomeScreen) {
                  setState(() {
                    isLoading = false;
                  });
                  router.push(
                    CheckOtpRoute(
                      customerExtId: customerId,
                      otpDuration: otpTimeout,
                      callOtpAfterClickButton: true,
                      onSuccess: () {
                        onSuccessfulLogin(customerId, newCustomerWelcomeScreen);
                      },
                    ),
                  );
                },
                onChangedRequiredPassword: (customerId, changedRequiredPassword) {
                  PBottomSheet.show(
                    context,
                    isDismissible: false,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          ImagesPath.alert_circle,
                          width: 52,
                          height: 52,
                          colorFilter: ColorFilter.mode(
                            context.pColorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(
                          height: Grid.m,
                        ),
                        Text(
                          L10n.tr('change_password_for_security'),
                        ),
                        const SizedBox(
                          height: Grid.m,
                        ),
                        PButton(
                          text: L10n.tr('tamam'),
                          fillParentWidth: true,
                          onPressed: () {
                            router.push(
                              ChangePasswordRoute(
                                isChangePasswordRequired: changedRequiredPassword,
                                onSuccess: (isSuccess, message) async {},
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );

                  return;
                },
                onError: (String message) {
                  bool navigateToPage = message == 'EXPIRED_PASSWORD';
                  return PBottomSheet.showError(
                    context,
                    content: L10n.tr(message),
                    showFilledButton: true,
                    filledButtonText: L10n.tr('tamam'),
                    onFilledButtonPressed: () {
                      if (navigateToPage) {
                        router.push(
                          ChangeExpiredPasswordRoute(
                            customerExtId: _usernameController.text,
                          ),
                        );
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        router.maybePop();
                      }
                    },
                  );
                },
              ),
            );
          },
          onFailed: (errorMessage) {
            setState(() {
              isLoading = false;
            });
            if (errorMessage.isNotEmpty) {
              return PBottomSheet.showError(
                context,
                content: L10n.tr(errorMessage),
              );
            }
          },
          onNotSupported: () {
            setState(() {
              isLoading = false;
            });
          },
        ),
      );
    } catch (e) {
      setState(
        () {
          isLoading = false;
        },
      );
    }
  }

  void _setDashboardInitializer() {
    //marketMenu harici diğer tab sayfalarının initialize değeri setlenmemiştir.
    dashboardInitialIndex = widget.activeIndex;
    dashboardInitialMarketMenu = widget.marketMenu;
    dashboardInitialMarketMenuIndex = widget.marketIndex;
  }

  //öncesine dashboard route eklendi.
  void onSuccessfulLogin(String customerId, bool newCustomerWelcomeScreen) {
    getIt<LocalStorage>().write(LocalKeys.lastLoginDate, DateTime.now().millisecondsSinceEpoch);

    if (widget.didNotLogin) {
      router.pushAndPopUntil(
        SplashRoute(
          isFirstLoginAfterInstall: true,
          afterInitFunc: () {
            _successfulLogin(customerId, newCustomerWelcomeScreen);
          },
        ),
        predicate: (_) => false,
      );
    } else {
      _successfulLogin(customerId, newCustomerWelcomeScreen);
    }
  }

  _successfulLogin(String customerId, bool newCustomerWelcomeScreen) {
    _setDashboardInitializer();

    router.replaceAll(
      [
        DashboardRoute(
          key: ValueKey('${DashboardRoute.name}-${DateTime.now().millisecondsSinceEpoch}'),
          checkBiometric: true,
          newCustomerWelcomeScreen: newCustomerWelcomeScreen,
        ),
      ],
    );

    getIt<AppInfoBloc>().add(
      ReadLoginCountEvent(
        callback: (_) {},
      ),
    );

    getIt<Analytics>().track(
      AnalyticsEvents.login,
    );

    getIt<AvatarBloc>().add(GetAvatarAndLimitEvent());

    if (!widget.didNotLogin) {
      /// Login olunduktan sonra realTime verileri almak için matriks ve symbol bloc'ları resetlenir.
      _matriksBloc.add(ResetMatriksToken());
      _matriksBloc.add(
        MatriksGetTopicsEvent(
          callback: () async {
            await ServiceLocatorManager.resetMqtt();
            await BlocLocator.reset();
            getIt<SymbolBloc>().add(SymbolRestartSubscription());
          },
        ),
      );
    }

    _agreementsBloc.add(
      GetAgreementsEvent(
        date: DateTimeUtils.serverDate(DateTime.now()),
        callback: (Map? loginCount, List<AgreementsModel>? agreementsList) async {
          if (agreementsList == null || agreementsList.isEmpty || agreementsList.length <= 1) {
            return;
          }

          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              PBottomSheet.showErrorThemeDynamic(
                NavigatorKeys.navigatorKey.currentContext!,
                title: L10n.tr('mutabakat'),
                content: L10n.tr('waiting_confirmation'),
                enableDrag: (loginCount?[customerId] ?? 0) < 5,
                isDismissible: (loginCount?[customerId] ?? 0) < 5,
                showOutlinedButton: (loginCount?[customerId] ?? 0) < 5,
                onOutlinedButtonPressed: (loginCount?[customerId] ?? 0) < 5 ? () => router.maybePop() : null,
                outlinedButtonText: L10n.tr('tamam'),
                showFilledButton: true,
                onFilledButtonPressed: () async {
                  await router.maybePop();
                  router.push(
                    AgreementsRoute(
                      title: L10n.tr('mutabakat'),
                    ),
                  );
                },
                filledButtonText: L10n.tr('mutabakatlarim'),
              );
            },
          );
        },
      ),
    );
    if (_quickPortfolioBloc.state.fundPortfolios['robotik_sepet'] == null) {
      _quickPortfolioBloc.add(
        GetPreparedPortfolioEvent(
          portfolioKey: 'robotik_sepet',
          callback: (portfolioModel) {
            for (var item in portfolioModel) {
              _quickPortfolioBloc.add(
                GetRoboticBasketsEvent(
                  portfolioId: item.id ?? 0,
                ),
              );
            }
          },
        ),
      );
    }
    _quickPortfolioBloc.add(
      GetModelPortfolioEvent(),
    );

    _globalOnboardingBloc.add(
      AccountSettingStatusEvent(),
    );

    getIt<NotificationsBloc>().add(
      GetNotificationUnReadCountEvent(),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        widget.afterLoginAction?.call();
      },
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_bloc.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_event.dart';
import 'package:piapiri_v2/app/avatar/pages/profile_picture.dart';
import 'package:piapiri_v2/app/banner/bloc/banner_bloc.dart';
import 'package:piapiri_v2/app/banner/bloc/banner_event.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_bloc.dart';
import 'package:piapiri_v2/app/home/widgets/create_account_info_card.dart';
import 'package:piapiri_v2/app/profile/widgets/notification_profile_row.dart';
import 'package:piapiri_v2/app/profile/widgets/profile_row.dart';
import 'package:piapiri_v2/app/profile/widgets/theme_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_event.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/general_settings.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late BannerBloc _bannerBloc;
  late AuthBloc _authBloc;
  late AppSettingsBloc _appSettingsBloc;
  late TabBloc _tabBloc;
  late QuickPortfolioBloc _quickPortfolioBloc;
  late LanguageBloc _languageBloc;
  late CampaignsBloc _campaignsBloc;
  late final bool _isReferancePageAvailable;

  @override
  void initState() {
    _bannerBloc = getIt<BannerBloc>();
    _authBloc = getIt<AuthBloc>();
    _appSettingsBloc = getIt<AppSettingsBloc>();
    _tabBloc = getIt<TabBloc>();
    _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
    _languageBloc = getIt<LanguageBloc>();
    _campaignsBloc = getIt<CampaignsBloc>();
    _isReferancePageAvailable = remoteConfig.getBool(
      AppConfig.instance.isProd ? 'isReferanceAvailableOnProfile_prod' : 'isReferanceAvailableOnProfile_dev',
    );
    super.initState();
  }

  @override
  dispose() {
    if (_quickPortfolioBloc.state.specificListLangKey != _languageBloc.state.languageCode) {
      _quickPortfolioBloc.add(
        GetSpecificListEvent(
          mainGroup: MarketTypeEnum.home.value,
        ),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('profil'),
        actions: const [
          ThemeWidget(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Column(
              children: [
                ...(!getIt<AuthBloc>().state.isLoggedIn
                    ? [
                        CreateAccountInfoCard(
                          title: 'welcome_piapiri',
                          description: 'create_account_card_description',
                          showLoginText: true,
                          onLogin: () => router.push(
                            AuthRoute(
                              activeIndex: _tabBloc.state.selectedTabIndex,
                              afterLoginAction: () {
                                router.push(const ProfileRoute());
                              },
                            ),
                          ),
                        ),
                      ]
                    : [
                        const ProfilePicture(),
                        const SizedBox(
                          height: Grid.s,
                        ),
                        Text(
                          UserModel.instance.name,
                          style: context.pAppStyle.labelMed16textPrimary,
                        ),
                      ]),
                const SizedBox(
                  height: Grid.m + Grid.xs,
                ),
                if (AppConfig.instance.flavor != Flavor.prod) ...[
                  Container(
                    width: double.infinity,
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.s,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            key: UniqueKey(),
                            onPressed: () => router.push(
                              const LogsRoute(),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.pColorScheme.primary,
                              fixedSize: const Size.fromHeight(50),
                            ),
                            child: const Text('LOGS'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outlined),
                          onPressed: () => DefaultCacheManager().emptyCache().then((value) {
                            PBottomSheet.showError(
                              NavigatorKeys.navigatorKey.currentContext ?? context,
                              content: 'Cache cleared',
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: Grid.m,
                  ),
                ],
                const NotificationProfileRow(),
                const PDivider(
                  padding: EdgeInsets.symmetric(
                    vertical: Grid.m,
                  ),
                ),
                ProfileRow(
                  iconName: ImagesPath.receipt,
                  title: L10n.tr('lisanslarim'),
                  onTap: () => router.push(
                    const LicensesRoute(),
                  ),
                ),
                const PDivider(
                  padding: EdgeInsets.symmetric(
                    vertical: Grid.m,
                  ),
                ),
                if (_campaignsBloc.state.isCampaignsAvailable == true) ...[
                  ProfileRow(
                    iconName: ImagesPath.discount,
                    title: L10n.tr('campaigns.title'),
                    onTap: () => router.push(
                      const CampaignRoute(),
                    ),
                  ),
                  const PDivider(
                    padding: EdgeInsets.symmetric(
                      vertical: Grid.m,
                    ),
                  ),
                ],
                if (_isReferancePageAvailable) ...[
                  ProfileRow(
                    iconName: ImagesPath.user,
                    title: L10n.tr('referance_code'),
                    onTap: () => router.push(
                      const ReferanceCodeRoute(),
                    ),
                  ),
                  const PDivider(
                    padding: EdgeInsets.symmetric(
                      vertical: Grid.m,
                    ),
                  ),
                ],
                ProfileRow(
                  iconName: ImagesPath.player,
                  title: L10n.tr('educations'),
                  onTap: () => router.push(
                    EducationRoute(
                      title: L10n.tr('educations'),
                    ),
                  ),
                ),
                const PDivider(
                  padding: EdgeInsets.symmetric(
                    vertical: Grid.m,
                  ),
                ),
                ProfileRow(
                  iconName: ImagesPath.test,
                  title: L10n.tr('agreements'),
                  onTap: () => router.push(
                    ContractsListRoute(
                      title: L10n.tr('agreements'),
                    ),
                  ),
                ),
                const PDivider(padding: EdgeInsets.symmetric(vertical: Grid.m)),
                ProfileRow(
                  iconName: ImagesPath.doc_check,
                  title: L10n.tr('mutabakatlarim'),
                  onTap: () => {
                    router.push(
                      AgreementsRoute(
                        title: L10n.tr('mutabakatlarim'),
                      ),
                    ),
                  },
                ),
                const PDivider(padding: EdgeInsets.symmetric(vertical: Grid.m)),
                ProfileRow(
                  iconName: ImagesPath.preference,
                  title: L10n.tr('order_and_trade_preferences'),
                  onTap: () => router.push(
                    const OrderSettingsRoute(),
                  ),
                ),
                const PDivider(padding: EdgeInsets.symmetric(vertical: Grid.m)),
                ProfileRow(
                  iconName: ImagesPath.setting,
                  title: L10n.tr('uygulama_ayarlari'),
                  onTap: () => router.push(
                    const AppSettingsRoute(),
                  ),
                ),
                const PDivider(padding: EdgeInsets.symmetric(vertical: Grid.m)),
                ProfileRow(
                  iconName: ImagesPath.user,
                  title: L10n.tr('account_information'),
                  onTap: () => router.push(
                    const AccountInformationRoute(),
                  ),
                ),
                const PDivider(padding: EdgeInsets.symmetric(vertical: Grid.m)),
                ProfileRow(
                  iconName: ImagesPath.phone,
                  title: L10n.tr('paired_devices'),
                  onTap: () => router.push(
                    const PairedDevicesRoute(),
                  ),
                ),
                const PDivider(padding: EdgeInsets.symmetric(vertical: Grid.m)),
                ProfileRow(
                  iconName: ImagesPath.message,
                  title: L10n.tr('bize_ulasin'),
                  onTap: () => router.push(
                    ContactUsRoute(
                      title: L10n.tr('bize_ulasin'),
                    ),
                  ),
                ),
                if (getIt<AuthBloc>().state.isLoggedIn) ...[
                  const PDivider(padding: EdgeInsets.symmetric(vertical: Grid.m)),
                  ProfileRow(
                    iconName: ImagesPath.exit,
                    title: L10n.tr('cikis_yap'),
                    titleColor: context.pColorScheme.critical,
                    onTap: () => {
                      _showAlertForLogOut(
                        context,
                      ),
                    },
                  ),
                ],
                const SizedBox(
                  height: Grid.xs + Grid.m,
                ),
                SizedBox(
                  height: 20,
                  child: Text(
                    '${L10n.tr('version')} ${getIt<AppInfo>().appVersion}',
                    style: context.pAppStyle.labelReg12textPrimary,
                  ),
                ),
                const SizedBox(
                  height: Grid.l,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //logout
  _showAlertForLogOut(BuildContext context) {
    GeneralSettings generalSettings = _appSettingsBloc.state.generalSettings;
    PBottomSheet.showError(
      context,
      customImagePath: ImagesPath.exit,
      isCritical: true,
      content: L10n.tr('log_out_alert'),
      showOutlinedButton: true,
      outlinedButtonText: L10n.tr('vazgec'),
      onOutlinedButtonPressed: () => router.maybePop(),
      showFilledButton: true,
      filledButtonText: L10n.tr('onayla'),
      onFilledButtonPressed: () async {
        if (generalSettings.touchFaceId) {
          getIt<LocalStorage>().write(LocalKeys.showBiometricLogin, generalSettings.touchFaceId);
        }
        router.replaceAll(
          [
            DashboardRoute(
              key: ValueKey('${DashboardRoute.name}-${DateTime.now().millisecondsSinceEpoch}'),
            ),
          ],
        );

        getIt<TabBloc>().add(
          const TabChangedEvent(
            tabIndex: 0,
          ),
        );

        getIt<AvatarBloc>().add(LogoutAvatarEvent());

        _authBloc.add(
          LogoutEvent(
            callback: () => _bannerBloc.add(
              ResetBannersEvent(),
            ),
          ),
        );
      },
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_state.dart';
import 'package:piapiri_v2/app/banner/widgets/banner_carousel.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/home_favorite_lists.dart';
import 'package:piapiri_v2/app/home/widgets/account_status.dart';
import 'package:piapiri_v2/app/home/widgets/create_account_info_card.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/shortcut_widgets.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/home_spesific_list_widget.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          /// android cihazın kendi geri tuşuna basıp çıkış yapıp tekrar uygulamaya döndüğünde logout şekilde
          /// kalması için BlocSelector eklendi.
          child: BlocSelector<AuthBloc, AuthState, bool>(
              bloc: getIt<AuthBloc>(),
              selector: (state) => state.isLoggedIn,
              builder: (context, isLoggedIn) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Grid.s + Grid.xxs,
                    ),
                    if (!isLoggedIn) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Grid.m,
                        ),
                        child: CreateAccountInfoCard(
                          title: 'welcome_piapiri',
                          description: 'create_account_card_description',
                          showLoginText: true,
                          onLogin: () => router.push(
                            AuthRoute(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Grid.l,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Grid.m,
                        ),
                        child: BannerCarousel(),
                      ),
                      const SizedBox(
                        height: Grid.l,
                      ),
                      const HomeSpesificListWidget(
                        leftPadding: Grid.m,
                        rightPadding: Grid.m,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Grid.m,
                        ),
                        child: CreateAccountInfoCard(
                          title: 'my_favorites',
                          description: 'create_account_card_description',
                          onLogin: () => router.push(
                            AuthRoute(),
                          ),
                        ),
                      )
                    ] else ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Grid.m,
                        ),
                        child: AccountStatus(),
                      ),
                      const SizedBox(
                        height: Grid.l,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Grid.m,
                        ),
                        child: ShortcutWidgets(
                          isHomePage: true,
                        ),
                      ),
                      const SizedBox(
                        height: Grid.l,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Grid.m,
                        ),
                        child: BannerCarousel(),
                      ),
                      const SizedBox(
                        height: Grid.l,
                      ),
                      const HomeSpesificListWidget(
                        leftPadding: Grid.m,
                        rightPadding: Grid.m,
                      ),
                      const HomeFavoriteList(),
                      const SizedBox(
                        height: Grid.l,
                      ),
                    ],
                  ],
                );
              }),
        ),
      ),
    );
  }
}

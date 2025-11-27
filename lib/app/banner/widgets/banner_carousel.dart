import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/banner/bloc/banner_bloc.dart';
import 'package:piapiri_v2/app/banner/bloc/banner_event.dart';
import 'package:piapiri_v2/app/banner/bloc/banner_state.dart';
import 'package:piapiri_v2/app/banner/widgets/banner_widget.dart';
import 'package:piapiri_v2/app/banner/widgets/shimmer_banner.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late final FlutterCarouselController _carouselController;
  int _currentIndex = 0;

  late BannerBloc _bannerBloc;
  late AuthBloc _authBloc;
  late AppInfoBloc _appInfoBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    _bannerBloc = getIt<BannerBloc>();
    _appInfoBloc = getIt<AppInfoBloc>();
    _carouselController = FlutterCarouselController();

    final dynamic cachedLoginCount = getIt<LocalStorage>().read(
      LocalKeys.loginCount,
    );
    if (cachedLoginCount?.isNotEmpty == true) {
      if (_authBloc.state.isLoggedIn) {
        _bannerBloc.add(GetBannersEvent());
      } else {
        _bannerBloc.add(GetCachedBannersEvent());
      }
    } else {
      _bannerBloc.add(
        GetMemberBannersEvent(
          _appInfoBloc.state.hasMembership['gsm'],
        ),
      );
    }

    _bannerBloc.add(
      GetBannerIsExpandedEvent(
        onIsExpanded: (isExpanded) {
          _bannerBloc.add(
            SetExpandedBannersEvent(
              isExpanded: isExpanded,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<BannerBloc, BannerState>(
      bloc: _bannerBloc,
      builder: (context, state) {
        if (state.isFetching) {
          return const Shimmerize(
            enabled: true,
            child: ShimmerBanner(),
          );
        }

        if (state.banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            FlutterCarousel(
              key: ValueKey(state.isExpanded),
              items: state.banners
                  .map((banner) => BannerWidget(
                        index: state.banners.indexOf(banner),
                        banner: banner,
                        isExpanded: state.isExpanded,
                        isExpandedChanged: () {
                          if (!state.isExpanded) {
                            _bannerBloc.add(
                              SetExpandedBannersEvent(
                                isExpanded: true,
                              ),
                            );
                          }
                        },
                      ))
                  .toList(),
              options: FlutterCarouselOptions(
                controller: _carouselController,
                initialPage: _currentIndex,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                height: state.isExpanded ? null : Grid.xxl,
                aspectRatio: 358 / 143,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                pageSnapping: true,
                scrollDirection: Axis.horizontal,
                pauseAutoPlayOnTouch: true,
                pauseAutoPlayOnManualNavigate: true,
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
                showIndicator: state.isExpanded,
                floatingIndicator: true,
                slideIndicator: CircularSlideIndicator(
                  slideIndicatorOptions: SlideIndicatorOptions(
                    alignment: Alignment.bottomCenter,
                    currentIndicatorColor: context.pColorScheme.iconPrimary,
                    indicatorBackgroundColor: context.pColorScheme.textQuaternary,
                    indicatorRadius: Grid.xs,
                    itemSpacing: Grid.s + Grid.xs,
                    padding: const EdgeInsets.all(Grid.xxs),
                    haloDecoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(Grid.m)),
                      color: context.pColorScheme.backgroundColor,
                    ),
                    haloPadding: const EdgeInsets.symmetric(horizontal: Grid.s, vertical: Grid.xs),
                    enableHalo: true,
                    enableAnimation: true,
                  ),
                ),
              ),
            ),
            if (state.banners.isNotEmpty && state.isExpanded)
              Positioned(
                top: Grid.m - Grid.xs,
                right: Grid.m - Grid.xs,
                child: InkWell(
                  onTap: () {
                    if (state.isExpanded) {
                      _bannerBloc.add(
                        SetExpandedBannersEvent(
                          isExpanded: false,
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: Grid.l,
                    width: Grid.l,
                    decoration: BoxDecoration(
                      color: context.pColorScheme.backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      ImagesPath.minimize,
                      width: Grid.m,
                      height: Grid.m,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.iconPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            if (state.banners.isNotEmpty && !state.isExpanded)
              Positioned(
                top: Grid.m - Grid.xs,
                bottom: Grid.m - Grid.xs,
                right: Grid.m - Grid.xs,
                child: InkWell(
                  onTap: () {
                    if (!state.isExpanded) {
                      _bannerBloc.add(
                        SetExpandedBannersEvent(
                          isExpanded: true,
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: Grid.l,
                    width: Grid.l,
                    decoration: BoxDecoration(
                      color: context.pColorScheme.backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      ImagesPath.chevron_down,
                      width: Grid.m,
                      height: Grid.m,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.iconPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

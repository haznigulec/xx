import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_themes_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class FundGroupsPage extends StatelessWidget {
  const FundGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('fund_groups'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: Grid.m,
                  left: Grid.m,
                  right: Grid.m,
                ),
                child: Text(
                  L10n.tr('fund_themes'),
                  style: context.pAppStyle.labelMed18textPrimary,
                ),
              ),
              const SizedBox(
                height: Grid.s + Grid.xs,
              ),
              const FundThemesWidget(),
              const SizedBox(
                height: Grid.l,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: Text(
                  L10n.tr('fund_sub_type'),
                  style: context.pAppStyle.labelMed18textPrimary,
                ),
              ),
              const SizedBox(
                height: Grid.s + Grid.xs,
              ),
              PBlocBuilder<FundBloc, FundState>(
                bloc: getIt<FundBloc>(),
                builder: (context, state) {
                  if (state.applicationCategories == null) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.m,
                    ),
                    child: Shimmerize(
                      enabled: state.isLoading,
                      child: ListView.separated(
                          itemCount: state.applicationCategories?.length ?? 0,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const PDivider(
                                padding: EdgeInsets.symmetric(
                                  vertical: Grid.m,
                                ),
                              ),
                          itemBuilder: (context, index) {
                            if (state.applicationCategories != null && state.applicationCategories![index].count == 0) {
                              return const SizedBox.shrink();
                            }

                            return InkWell(
                              onTap: () {
                                getIt<FundBloc>().add(
                                  SetFilterEvent(
                                    fundFilter: FundFilterModel(
                                      institution: '',
                                      institutionName: '',
                                      applicationCategory: state.applicationCategories![index].code.toString(),
                                    ),
                                    callback: (list) {},
                                  ),
                                );
                                router.push(
                                  FundsListRoute(
                                    title: state.applicationCategories![index].name,
                                    fromSectors: true,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Grid.s,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state.applicationCategories![index].name,
                                      style: context.pAppStyle.labelReg14textPrimary,
                                    ),
                                    SvgPicture.asset(
                                      ImagesPath.chevron_right,
                                      width: 15,
                                      height: 15,
                                      colorFilter: ColorFilter.mode(
                                        context.pColorScheme.textPrimary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: Grid.m,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

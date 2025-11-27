import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_bloc.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_event.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_state.dart';
import 'package:piapiri_v2/app/campaigns/widgets/campaign_terms.dart';
import 'package:piapiri_v2/app/campaigns/widgets/code_button.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/bank_list_widget.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class CampaignDetailPage extends StatefulWidget {
  final String campaignCode;
  final bool isOutOfStock;
  const CampaignDetailPage({
    super.key,
    required this.campaignCode,
    required this.isOutOfStock,
  });

  @override
  State<CampaignDetailPage> createState() => _CampaignDetailPageState();
}

class _CampaignDetailPageState extends State<CampaignDetailPage> {
  late CampaignsBloc _bloc;

  @override
  void initState() {
    _bloc = getIt<CampaignsBloc>();
    _bloc.add(
      CampaignsGetDetailEvent(
        widget.campaignCode,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: context.pColorScheme.transparent,
      ),
      child: PBlocBuilder<CampaignsBloc, CampaignsState>(
        bloc: _bloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr('campaigns.detail_title'),
            ),
            body: state.isLoading
                ? const PLoading()
                : Padding(
                    padding: const EdgeInsets.only(
                      left: Grid.m,
                      right: Grid.m,
                      top: Grid.l - Grid.xs,
                    ),
                    child: Stack(
                      children: [
                        if (state.detail != null)
                          ListView(
                            children: [
                              Text(
                                state.detail!.detailTitle,
                                style: context.pAppStyle.labelMed16textPrimary,
                              ),
                              const SizedBox(
                                height: Grid.m,
                              ),
                              Text(
                                L10n.tr(
                                  'campaigns.period',
                                  args: [
                                    state.detail!.startDate,
                                    state.detail!.endDate,
                                  ],
                                ),
                                style: context.pAppStyle.labelMed14textSecondary,
                              ),
                              const SizedBox(
                                height: Grid.m,
                              ),
                              AspectRatio(
                                aspectRatio: 2 / 1,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                      Grid.s,
                                    ),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: state.detail!.image,
                                    width: MediaQuery.sizeOf(context).width,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, _, __) {
                                      return const Icon(
                                        Icons.error,
                                        size: 28,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: Grid.m,
                              ),
                              if (state.detail!.description != null)
                                Text(
                                  state.detail!.description!,
                                  style: context.pAppStyle.labelReg14textSecondary,
                                  textAlign: TextAlign.justify,
                                ),
                              if (state.detail!.conditionType != null && state.detail!.conditionType == 1)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: Grid.m,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: PTextButtonWithIcon(
                                      text: L10n.tr('campaign_detail_money_deposit'),
                                      iconAlignment: IconAlignment.end,
                                      sizeType: PButtonSize.small,
                                      padding: EdgeInsets.zero,
                                      icon: SvgPicture.asset(
                                        ImagesPath.arrow_up_right,
                                        width: Grid.m - Grid.xxs,
                                        colorFilter: ColorFilter.mode(
                                          context.pColorScheme.primary,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      onPressed: () {
                                        PBottomSheet.show(
                                          context,
                                          title: L10n.tr('choose_bank'),
                                          titlePadding: const EdgeInsets.only(
                                            top: Grid.m,
                                          ),
                                          child: SizedBox(
                                            height: MediaQuery.sizeOf(context).height * 0.7,
                                            child: const BankListWidget(),
                                          ),
                                        );
                                        return;
                                      },
                                    ),
                                  ),
                                ),
                              if (state.detail!.conditionsOfParticipation != null)
                                CampaignTerms(
                                  conditions: state.detail!.conditionsOfParticipation!,
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
            bottomNavigationBar: generalButtonPadding(
              context: context,
              child: widget.isOutOfStock
                  ? PButton(
                      text: L10n.tr('campaign_sold_out'),
                      fillParentWidth: true,
                    )
                  : CodeButton(
                      isLoading: state.isLoading,
                      code: state.detail?.customerCampaignCode ?? state.campaignCode,
                      isAvailable: (state.detail?.rightToParticipate ?? 0) > 0 && state.detail?.isAvailable == true,
                      onTap: (VoidCallback callback) {
                        _bloc.add(
                          CampaignsGetParticipationCodeEvent(
                            widget.campaignCode,
                            callback,
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/campaigns/model/campaign_model.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  const CampaignCard({
    super.key,
    required this.campaign,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        router.push(
          CampaignDetailRoute(
            campaignCode: campaign.code,
            isOutOfStock: !campaign.isAvailable,
          ),
        );
      },
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: Grid.s,
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
                    imageUrl: campaign.image,
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
                height: Grid.s,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: campaign.companyLogo,
                      width: 28,
                      height: 28,
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
                  const SizedBox(
                    width: Grid.s,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campaign.listTitle,
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                        _dateWidget(
                          context,
                          campaign.endDate,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          Visibility(
            visible: !campaign.isAvailable,
            child: Positioned(
              right: Grid.m,
              top: Grid.l,
              child: Container(
                decoration: BoxDecoration(
                  color: context.pColorScheme.primary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      Grid.m,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Grid.xs,
                    horizontal: Grid.m - Grid.xxs,
                  ),
                  child: Text(
                    L10n.tr('campaigns.out_of_stock'),
                    style: context.pAppStyle.interMediumBase.copyWith(
                      fontSize: Grid.m - Grid.xxs,
                      color: context.pColorScheme.card.shade50,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateWidget(BuildContext context, String endDateStr) {
    DateTime now = DateTime.now();
    DateTime endDate = DateTimeUtils.strToDate(endDateStr);
    Duration diff = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
      0,
    ).difference(now);
    int daysDifference = diff.inDays;

    String text = '';
    Color textColor = context.pColorScheme.textSecondary;

    if (daysDifference == 0) {
      text = L10n.tr('campaigns.last_day');
    } else if (daysDifference > 0 && daysDifference <= 5) {
      text = L10n.tr(
        'campaigns.last_#_days',
        args: [
          daysDifference.toString(),
        ],
      );
      textColor = context.pColorScheme.critical;
    } else {
      text = L10n.tr(
        'campaigns.last_day_#',
        args: [endDateStr],
      );
    }

    return Text(
      text,
      style: context.pAppStyle.interMediumBase.copyWith(
        fontSize: Grid.s + Grid.xxs,
        color: textColor,
      ),
    );
  }
}

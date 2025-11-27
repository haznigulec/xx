import 'package:cached_network_image/cached_network_image.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/report_model.dart';
import 'package:piapiri_v2/core/model/report_type_enum.dart';

class ReportsTile extends StatelessWidget {
  final ReportModel report;
  final String mainGroup;
  final bool removeTopPadding;
  const ReportsTile({
    super.key,
    required this.report,
    required this.mainGroup,
    this.removeTopPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        router.push(
          MarketReviewDetailRoute(
            reportModel: report,
            mainGroup: mainGroup,
          ),
        );
      },
      child: Padding(
        padding: removeTopPadding
            ? const EdgeInsets.only(
                bottom: Grid.m,
              )
            : const EdgeInsets.symmetric(
                vertical: Grid.m,
              ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(
                Grid.s + Grid.xxs,
              ),
              child: CachedNetworkImage(
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                httpHeaders: {
                  'AccessKey': AppConfig.instance.cdnKey,
                },
                imageUrl: '${getIt<AppInfo>().cdnUrl}Analysis/${intToReportTypeEnum(report.typeId).value}.png',
                placeholder: (context, url) => const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, _, __) {
                  return Center(
                    child: Image.asset(
                      ImagesPath.roboSignalsCombined,
                      scale: 1,
                      height: 60,
                      width: 60,
                      fit: BoxFit.contain,
                    ),
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
                spacing: Grid.xs,
                children: [
                  Text(
                    report.title,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  Text(
                    DateTimeUtils.dateFormat(
                      DateTime.parse(
                        report.dateTime,
                      ),
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                  SizedBox(
                    height: 23,
                    child: OutlinedButton(
                      onPressed: null,
                      style: context.pAppStyle.oulinedSmallSecondaryStyle,
                      child: Text(
                        report.type,
                        textAlign: TextAlign.center,
                        style: context.pAppStyle.labelReg14textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

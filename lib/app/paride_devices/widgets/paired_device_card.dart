import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/paired_devices_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PairedDeviceCard extends StatelessWidget {
  final PairedDevicesModel? device;
  final bool isLoading;

  const PairedDeviceCard({
    super.key,
    required this.device,
    this.isLoading = false,
  });

  /// Skeleton factory
  const PairedDeviceCard.loading({super.key})
      : device = null,
        isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildSkeleton(context);
    } else {
      return _buildContent(context);
    }
  }

  Widget _buildSkeleton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Grid.m),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // left column skeleton
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 14,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: Grid.xs),
              Container(
                width: 180,
                height: 12,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: Grid.s),
              Container(
                width: 100,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(Grid.m),
                ),
              ),
            ],
          ),
          Container(
            width: 15,
            height: 15,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final device = this.device!; // null olmayacak

    return InkWell(
      onTap: () {
        router.push(
          PairedDevicesDetailRoute(device: device),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Grid.m),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.deviceModel ?? L10n.tr('unknown_device'),
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
                const SizedBox(height: Grid.xs),
                Text(
                  '${L10n.tr('last_login')}: ${DateTimeUtils.pairedDeviceConvert(device.lastLoginDate)}',
                  style: context.pAppStyle.labelReg14textSecondary,
                ),
                if (device.isCurrentDevice) ...[
                  const SizedBox(height: Grid.s),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.m - Grid.xxs,
                      vertical: Grid.s - Grid.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: context.pColorScheme.secondary,
                      borderRadius: BorderRadius.circular(Grid.m),
                    ),
                    child: SizedBox(
                      height: 15,
                      child: Text(
                        L10n.tr('current_device'),
                        style: context.pAppStyle.labelMed14primary.copyWith(
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SvgPicture.asset(
              ImagesPath.chevron_right,
              height: 15,
              width: 15,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

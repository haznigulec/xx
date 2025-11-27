import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/theme_enum.dart';

class ThemeWidget extends StatelessWidget {
  const ThemeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AppSettingsBloc appSettingsBloc = getIt<AppSettingsBloc>();

    return SizedBox(
      height: 28,
      child: SlidingSegment(
        slidingSegmentWidth: 100,
        initialSelectedSegment: appSettingsBloc.state.generalSettings.theme == ThemeEnum.light ? 0 : 1,
        backgroundColor: context.pColorScheme.stroke,
        selectedTextColor: context.pColorScheme.lightHigh,
        unSelectedTextColor: context.pColorScheme.primary,
        segmentList: [
          PSlidingSegmentModel(
            segmentTitle: '',
            segmentColor: context.pColorScheme.primary,
            imagePath: ThemeEnum.light.iconPath,
          ),
          PSlidingSegmentModel(
            segmentTitle: '',
            segmentColor: context.pColorScheme.primary,
            imagePath: ThemeEnum.dark.iconPath,
          ),
        ],
        onValueChanged: (themeIndex) {
          ThemeEnum theme = themeIndex == 0 ? ThemeEnum.light : ThemeEnum.dark;
          appSettingsBloc.add(
            SetGeneralSettingsEvent(
              theme: theme,
            ),
          );
        },
      ),
    );
  }
}

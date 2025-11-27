import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_bloc.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_event.dart';
import 'package:piapiri_v2/app/avatar/model/generate_avatar_model.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class AiPhotoApprovePage extends StatelessWidget {
  final GenerateAvatarModel generateAvatarModel;
  const AiPhotoApprovePage({
    super.key,
    required this.generateAvatarModel,
  });

  @override
  Widget build(BuildContext context) {
    // Yapay zeka ile olusturulan avatar gosterimi ve onaylanmasi icin kullanilan sayfa
    return Scaffold(
      appBar: PInnerAppBar(title: L10n.tr('create_ai_profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Grid.m),
          child: Column(
            children: [
              const SizedBox(
                height: Grid.m + Grid.xs,
              ),
              Image.memory(
                width: double.infinity,
                base64.decode(generateAvatarModel.image!),
                fit: BoxFit.contain,
              ),
              const Spacer(),
              OrderApprovementButtons(
                cancelButtonText: L10n.tr('rebuild'),
                approveButtonText: L10n.tr('make_profile_picture'),
                onPressedCancel: () {
                  getIt<AvatarBloc>().add(
                    GetAvatarAndLimitEvent(
                      callback: (_) async {
                        await router.maybePop();
                        router.replace(const AiPhotoRoute());
                      },
                    ),
                  );
                },
                onPressedApprove: () {
                  getIt<AvatarBloc>().add(
                    SetAvatarEvent(
                      refCode: generateAvatarModel.refCode!,
                      callback: (_) => router.popUntilRouteWithName(ProfileRoute.name),
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

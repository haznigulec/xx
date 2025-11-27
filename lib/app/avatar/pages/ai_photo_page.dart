import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_bloc.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_event.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_state.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class AiPhotoPage extends StatefulWidget {
  const AiPhotoPage({super.key});

  @override
  State<AiPhotoPage> createState() => _AiPhotoPageState();
}

class _AiPhotoPageState extends State<AiPhotoPage> {
  final TextEditingController _controller = TextEditingController();
  final AvatarBloc _avatarBloc = getIt<AvatarBloc>();
  bool _hasText = false;
  @override
  Widget build(BuildContext context) {
    // Kullanicidan alinan aciklama ile yapay zeka ile avatar olusturma sayfasi
    return Scaffold(
      appBar: PInnerAppBar(title: L10n.tr('create_ai_profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: PBlocBuilder<AvatarBloc, AvatarState>(
            bloc: _avatarBloc,
            builder: (context, state) {
              int periodLimit = state.validateAvatarModel?.limitData.periodLimit ?? 5;
              int remainingUsageCount = state.validateAvatarModel?.limitData.remainingUsageCount ?? 0;
              return state.isLoading
                  ? Container(
                      alignment: Alignment.center,
                      color: context.pColorScheme.transparent,
                      child: const PLoading(),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(
                                height: Grid.m + Grid.xs,
                              ),
                              Flexible(
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: Grid.s, horizontal: Grid.m),
                                    decoration: BoxDecoration(
                                      color: context.pColorScheme.card,
                                      borderRadius: BorderRadius.circular(Grid.m),
                                    ),
                                    child: TextFormField(
                                      controller: _controller,
                                      minLines: 5,
                                      maxLines: 30,
                                      maxLength: 1000,
                                      showCursor: true,
                                      onChanged: (text) {
                                        if (text.isNotEmpty && !_hasText) {
                                          setState(() {
                                            _hasText = true;
                                          });
                                        } else if (text.isEmpty && _hasText) {
                                          setState(() {
                                            _hasText = false;
                                          });
                                        }
                                      },
                                      cursorColor: context.pColorScheme.primary,
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      style: context.pAppStyle.labelReg16textPrimary,
                                      decoration: InputDecoration(
                                        hintText: L10n.tr('aciklama_giriniz'),
                                        hintStyle: context.pAppStyle.labelReg16textSecondary,
                                        border: InputBorder.none,
                                      ),
                                      buildCounter: (
                                        BuildContext context, {
                                        required int currentLength,
                                        required int? maxLength,
                                        required bool isFocused,
                                      }) {
                                        if (maxLength == null) return const SizedBox.shrink();
                                        return Text(
                                          '$currentLength/$maxLength',
                                          style: context.pAppStyle.labelReg14textPrimary.copyWith(
                                            color: currentLength >= maxLength
                                                ? context.pColorScheme.critical
                                                : context.pColorScheme.textPrimary,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: Grid.m,
                              ),
                              PInfoWidget(
                                infoText: L10n.tr('ai_photo_limit', args: [
                                  '$periodLimit',
                                  '($remainingUsageCount/$periodLimit)',
                                ]),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: Grid.m,
                        ),
                        PButton(
                          fillParentWidth: true,
                          text: L10n.tr('create'),
                          variant: PButtonVariant.brand,
                          onPressed: _hasText && remainingUsageCount > 0
                              ? () {
                                  _avatarBloc.add(
                                    GenerateAvatarEvent(
                                      descriptionText: _controller.text,
                                      callback: (model) {
                                        router.push(
                                          AiPhotoApproveRoute(
                                            generateAvatarModel: model,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              : null,
                        ),
                        const SizedBox(
                          height: Grid.m,
                        )
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}

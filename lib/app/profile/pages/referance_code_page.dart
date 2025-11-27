import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/profile/bloc/profile_referance_bloc.dart';
import 'package:piapiri_v2/app/profile/bloc/profile_referance_event.dart';
import 'package:piapiri_v2/app/profile/bloc/profile_referance_state.dart';

import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:share_plus/share_plus.dart';

// Todo: Ref kodu onayla geliştirmesi gelirse sonradan açılabilir.
// import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
// import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
// import 'package:piapiri_v2/app/profile/widgets/validate_referance_code_widget.dart';
// import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_clock.dart';
// import 'package:piapiri_v2/common/utils/date_time_utils.dart';
// import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
// import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';

@RoutePage()
class ReferanceCodePage extends StatefulWidget {
  const ReferanceCodePage({super.key});

  @override
  State<ReferanceCodePage> createState() => _ReferanceCodePageState();
}

class _ReferanceCodePageState extends State<ReferanceCodePage> {
  late IpoBloc _ipoBloc;
  late ProfileReferanceBloc _profileReferanceBloc;

  @override
  void initState() {
    super.initState();
    _ipoBloc = getIt<IpoBloc>();
    _profileReferanceBloc = getIt<ProfileReferanceBloc>();
    _ipoBloc.add(
      GetCustomerInfoEvent(
        customerId: UserModel.instance.customerId ?? '',
        accountId: UserModel.instance.accountId,
      ),
    );
    _profileReferanceBloc.add(
      GetReferanceCodeEvent(),
    );
    _profileReferanceBloc.add(
      GetApplicationSettingsByKeyAndCustomerExtIdEvent(
        checkBudyReferanceCode: true,
      ),
    );
  }

  @override
  void dispose() {
    _profileReferanceBloc.add(ClearReferanceCodesEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        appBar: PInnerAppBar(
          title: L10n.tr('referance_code'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.s,
              horizontal: Grid.m,
            ),
            child: PBlocBuilder<ProfileReferanceBloc, ProfileReferanceState>(
              bloc: _profileReferanceBloc,
              builder: (context, state) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: Grid.m + Grid.xs,
                children: [
                  Text(
                    L10n.tr('referance_code_share_friends'),
                    style: context.pAppStyle.labelReg16textPrimary,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Grid.m + Grid.xs,
                      horizontal: Grid.m,
                    ),
                    decoration: BoxDecoration(
                      color: context.pColorScheme.card,
                      borderRadius: BorderRadius.circular(
                        Grid.m,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          L10n.tr('your_referance_code'),
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: state.referanceCode,
                              ),
                            ).then((_) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: context.pColorScheme.transparent,
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    content: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          ImagesPath.check_circle,
                                          width: Grid.l,
                                          height: Grid.l,
                                          colorFilter: ColorFilter.mode(
                                            context.pColorScheme.primary,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Grid.s,
                                        ),
                                        Text(
                                          L10n.tr(
                                            'kopyalandi',
                                          ),
                                          style: context.pAppStyle.labelReg18textPrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            });
                          },
                          child: state.isLoading
                              ? const SizedBox(
                                  height: Grid.l,
                                  width: Grid.l,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.centerRight,
                                  height: Grid.l,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        state.referanceCode,
                                        style: context.pAppStyle.labelMed14primary,
                                        textAlign: TextAlign.end,
                                      ),
                                      const SizedBox(
                                        width: Grid.xs,
                                      ),
                                      SvgPicture.asset(
                                        ImagesPath.copy,
                                        width: Grid.m,
                                        height: Grid.m,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  // Todo: Ref kodu onayla geliştirmesi gelirse sonradan açılabilir.
                  // PBlocBuilder<IpoBloc, IpoState>(
                  //   bloc: _ipoBloc,
                  //   builder: (context, ipoState) {
                  //     bool isActive = false;
                  //     String? createAccountDateStr = ipoState.ipoCustomerInfoModel?.customerInfo?.firstOrNull?.created;
                  //     if (createAccountDateStr?.isNotEmpty == true) {
                  //       DateTime createAccountDate = DateTimeUtils.fromString(createAccountDateStr!);
                  //       DateTime currentTime = getIt<TimeBloc>().state.mxTime != null
                  //           ? parseIsoTime(
                  //               DateTime.fromMicrosecondsSinceEpoch(
                  //                 getIt<TimeBloc>().state.mxTime!.timestamp.toInt(),
                  //               ).toUtc().toIso8601String(),
                  //             )
                  //           : DateTime.now();
                  //       isActive = currentTime.difference(createAccountDate).inDays < 30;
                  //     }
                  //     if (!isActive) return const SizedBox.shrink();
                  //     return PCustomPrimaryTextButton(
                  //       iconAlignment: IconAlignment.start,
                  //       icon: SvgPicture.asset(
                  //         ImagesPath.hediye,
                  //         width: Grid.m,
                  //         height: Grid.m,
                  //         colorFilter: ColorFilter.mode(
                  //           context.pColorScheme.primary,
                  //           BlendMode.srcIn,
                  //         ),
                  //       ),
                  //       text: L10n.tr(
                  //         state.budyReferanceCode.isNotEmpty
                  //             ? 'recived_referance_code_approved'
                  //             : 'have_you_got_recived_referance_code',
                  //       ),
                  //       style: context.pAppStyle.labelMed14primary,
                  //       onPressed: state.budyReferanceCode.isNotEmpty
                  //           ? null
                  //           : () {
                  //               PBottomSheet.show<bool?>(
                  //                 context,
                  //                 child: const ValidateReferanceCodeWidget(),
                  //               );
                  //             },
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.s,
            ),
            child: PButtonWithIcon(
              text: L10n.tr('share_referance_code'),
              fillParentWidth: true,
              height: 52,
              iconAlignment: IconAlignment.end,
              onPressed: () {
                Share.share(
                  _profileReferanceBloc.state.referanceCode,
                );
              },
              icon: SvgPicture.asset(
                ImagesPath.arrow_up_right,
                width: Grid.m,
                height: Grid.m,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.card.shade50,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

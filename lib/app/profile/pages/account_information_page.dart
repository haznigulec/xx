import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/account_closure/bloc/account_closure_bloc.dart';
import 'package:piapiri_v2/app/account_closure/bloc/account_closure_event.dart';
import 'package:piapiri_v2/app/account_closure/bloc/account_closure_state.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/member/bloc/member_bloc.dart';
import 'package:piapiri_v2/app/member/bloc/member_event.dart';
import 'package:piapiri_v2/app/member/bloc/member_state.dart';
import 'package:piapiri_v2/app/profile/widgets/account_information_row.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class AccountInformationPage extends StatefulWidget {
  const AccountInformationPage({super.key});

  @override
  State<AccountInformationPage> createState() => _AccountInformationPageState();
}

class _AccountInformationPageState extends State<AccountInformationPage> {
  late AuthBloc _authBloc;
  late MemberBloc _memberBloc;
  late AppInfoBloc _appInfoBloc;
  late AccountClosureBloc _accountClosureBloc;

  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();
    _appInfoBloc = getIt<AppInfoBloc>();
    _accountClosureBloc = getIt<AccountClosureBloc>();
    _memberBloc = getIt<MemberBloc>();

    if (_authBloc.state.isLoggedIn && _appInfoBloc.state.loginCount.isNotEmpty) {
      _accountClosureBloc.add(GetAccountClosureStatusEvent());
    } else {
      _memberBloc.add(
        MemberInfoEvent(
          gsm: _appInfoBloc.state.hasMembership['gsm'],
        ),
      );
    }

    super.initState();
  }

  List<Map<String, String>> generateDataList(
    Map<dynamic, dynamic> loginCount,
    Map<dynamic, dynamic> hasMembership,
    MemberState state,
  ) {
    List<Map<String, String>> dataList = [
      {'title': 'musteri_numarasi', 'subTitle': UserModel.instance.customerId ?? ''},
      {
        'title': 'ad_soyad',
        'subTitle': UserModel.instance.name,
      },
      {
        'title': 'telefon_numarası',
        'subTitle': loginCount.isEmpty && hasMembership['status']
            ? state.memberInfo['phoneNumber'] ?? ''
            : UserModel.instance.phone,
      },
      {
        'title': 'email',
        'subTitle':
            loginCount.isEmpty && hasMembership['status'] ? state.memberInfo['email'] ?? '' : UserModel.instance.email,
      },
      {'title': 'adres', 'subTitle': UserModel.instance.address},
    ];

    if (loginCount.isEmpty && hasMembership['status']) {
      dataList.removeWhere(
          (item) => item['title'] == 'adres' || item['title'] == 'musteri_numarasi' || item['title'] == 'ad_soyad');
    }

    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('account_information'),
      ),
      body: !_authBloc.state.isLoggedIn && _appInfoBloc.state.loginCount.isNotEmpty
          ? CreateAccountWidget(
              memberMessage: L10n.tr('create_account_info_alert'),
              loginMessage: L10n.tr('login_account_info_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(const AccountInformationRoute());
                  },
                ),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                child: PBlocBuilder<MemberBloc, MemberState>(
                  bloc: _memberBloc,
                  builder: (context, state) {
                    final dataList = generateDataList(
                      _appInfoBloc.state.loginCount,
                      _appInfoBloc.state.hasMembership,
                      state,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            final item = dataList[index];
                            return AccountInformationRow(
                              title: L10n.tr(item['title'] ?? ''),
                              subTitle: L10n.tr(item['subTitle'] ?? ''),
                            );
                          },
                        ),
                        const SizedBox(height: Grid.m + Grid.xs),
                        _authBloc.state.isLoggedIn && _appInfoBloc.state.loginCount.isNotEmpty
                            ? PBlocBuilder<AccountClosureBloc, AccountClosureState>(
                                bloc: _accountClosureBloc,
                                builder: (context, state) {
                                  return PCustomPrimaryTextButton(
                                    text: L10n.tr('temporarily_close_my_account'),
                                    style: context.pAppStyle.labelMed16primary.copyWith(
                                      color: context.pColorScheme.critical,
                                    ),
                                    iconSource: ImagesPath.arrow_up_right,
                                    iconAlignment: IconAlignment.end,
                                    onPressed: state.accountClosureStatus
                                        ? null
                                        : () {
                                            PBottomSheet.showError(
                                              context,
                                              isCritical: true,
                                              content: L10n.tr('temporarily_close_my_account_alert'),
                                              showFilledButton: true,
                                              showOutlinedButton: true,
                                              filledButtonText: L10n.tr('onayla'),
                                              outlinedButtonText: L10n.tr('vazgec'),
                                              onFilledButtonPressed: () {
                                                _authBloc.add(
                                                  CheckOTPAgainEvent(
                                                    customerExtId: UserModel.instance.customerId ?? '',
                                                    onSuccess: (response) {
                                                      router.push(
                                                        CheckOtpRoute(
                                                          customerExtId: response['customerExtId'],
                                                          otpDuration: response['otpTimeout'],
                                                          appBarTitle: 'deactivate_account_title',
                                                          fromAccountClosure: true,
                                                          onOtpValidated: (otp) {
                                                            getIt<AccountClosureBloc>().add(
                                                              ClosureEvent(
                                                                customerId: response['customerExtId'],
                                                                onSuccess: () {
                                                                  getIt<AccountClosureBloc>().add(
                                                                    SetAccountClosureStatus(),
                                                                  );
                                                                  router.maybePop();
                                                                  router.push(
                                                                    InfoRoute(
                                                                      variant: InfoVariant.success,
                                                                      message: L10n.tr('deactivate_account_success'),
                                                                      buttonText: L10n.tr('return_homepage'),
                                                                      onTapButton: () {
                                                                        router.popUntilRoot();
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                onFailed: () {
                                                                  return PBottomSheet.showError(
                                                                    context,
                                                                    content: L10n.tr('deactivate_account_failed'),
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              onOutlinedButtonPressed: () => router.maybePop(),
                                            );
                                          },
                                  );
                                },
                              )
                            : PCustomPrimaryTextButton(
                                text: L10n.tr('remove_member_text'),
                                iconSource: ImagesPath.arrow_up_right,
                                iconAlignment: IconAlignment.end,
                                onPressed: () {
                                  PBottomSheet.showError(
                                    context,
                                    content: L10n.tr('ayril_popup_text'),
                                    showOutlinedButton: true,
                                    showFilledButton: true,
                                    filledButtonText: L10n.tr('ayril'),
                                    outlinedButtonText: L10n.tr('vazgec'),
                                    onOutlinedButtonPressed: () => router.maybePop(),
                                    onFilledButtonPressed: () {
                                      _memberBloc.add(
                                        DeleteMemberEvent(
                                          gsm: _appInfoBloc.state.hasMembership['gsm'],
                                          onSuccess: (response) {
                                            PBottomSheet.showError(
                                              context,
                                              content: L10n.tr('membership_deleted_text'),
                                              isSuccess: true,
                                              filledButtonText: L10n.tr('tamam'),
                                              showFilledButton: true,
                                              onFilledButtonPressed: () => router.pushAndPopUntil(
                                                CreateAccountRoute(),
                                                predicate: (_) => false,
                                              ),
                                            );
                                            _appInfoBloc.add(
                                              WriteHasMembershipEvent(
                                                gsm: '',
                                                status: false,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                        const Spacer(),
                        Text(
                          L10n.tr('contact_with_call_center_info'),
                          textAlign: TextAlign.center,
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                        const SizedBox(height: Grid.m + Grid.xs),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}

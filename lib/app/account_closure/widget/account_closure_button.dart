import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/account_closure/bloc/account_closure_bloc.dart';
import 'package:piapiri_v2/app/account_closure/bloc/account_closure_event.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AccountClosureButton extends StatelessWidget {
  const AccountClosureButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PButton(
      text: L10n.tr('deactivate_account'),
      onPressed: () {
        getIt<AuthBloc>().add(
          CheckOTPAgainEvent(
            customerExtId: UserModel.instance.customerId!,
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
                          router.push(
                            InfoRoute(
                              variant: InfoVariant.failed,
                              message: L10n.tr('deactivate_account_failed'),
                            ),
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

        // return PPDialogs.basicAlertDialog(
        //   L10n.tr('deactivate_account_alert'),
        //   AlertIconEnum.warning,
        //   showNegativeActionButton: true,
        //   positiveAction: PPDialogActions(
        //     text: L10n.tr('yes'),
        //     action: () {
        //       getIt<LoginBloc>().add(
        //         AgainOTPEvent(
        //           customerExtId: UserModel.instance.customerId,
        //           onSuccess: (response) {
        //             router.push(
        //               CheckOtpRoute(
        //                 customerExtId: response['customerExtId'],
        //                 otpDuration: response['otpTimeout'],
        //                 appBarTitle: 'deactivate_account_title',
        //                 fromAccountClosure: true,
        //                 onOtpValidated: (otp) {
        //                   getIt<AccountClosureBloc>().add(
        //                     AccountClosureEvent(
        //                       customerId: response['customerExtId'],
        //                       onSuccess: () {
        //                         router.push(
        //                           GeneralCompletedRoute(
        //                             messageText: L10n.tr('deactivate_account_success'),
        //                             buttonText: L10n.tr('return_homepage'),
        //                             onTapButton: () {
        //                               router.popUntilRoot();
        //                             },
        //                             onTapCloseIcon: () {
        //                               router.maybePop();
        //                             },
        //                           ),
        //                         );
        //                       },
        //                       onFailed: () {
        //                         return PPDialogs.basicAlertDialog(
        //                           L10n.tr('deactivate_account_failed'),
        //                           AlertIconEnum.error,
        //                         );
        //                       },
        //                     ),
        //                   );
        //                 },
        //               ),
        //             );
        //           },
        //         ),
        //       );
        //       router.maybePop();
        //     },
        //   ),
        // );
      },
    );
  }
}

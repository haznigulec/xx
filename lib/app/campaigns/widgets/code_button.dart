import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/campaigns/repository/campaigns_repository_impl.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:toast/toast.dart';

class CodeButton extends StatefulWidget {
  final Function(VoidCallback) onTap;
  final bool isLoading;
  final String code;
  final bool isAvailable;

  const CodeButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
    this.code = '',
    this.isAvailable = true,
  });

  @override
  State<CodeButton> createState() => _CodeButtonState();
}

class _CodeButtonState extends State<CodeButton> {
  final Map<dynamic, dynamic> _hasMembership = CampaignsRepositoryImpl().hasMembership();
  final bool _isLoggedIn = getIt<AuthBloc>().state.isLoggedIn;
  bool _showCode = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return !_showCode && widget.code.isEmpty
        ? PButton(
            loading: widget.isLoading,
            text: L10n.tr('campaigns.get_participation_code'),
            fillParentWidth: true,
            onPressed: _hasMembership['status'] && !_isLoggedIn || !widget.isAvailable
                ? null
                : () {
                    PBottomSheet.show(
                      context,
                      child: Column(
                        children: [
                          Text(
                            L10n.tr('campaigns.participation_code_dialog'),
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          OrderApprovementButtons(
                            cancelButtonText: L10n.tr('no'),
                            approveButtonText: L10n.tr('yes'),
                            onPressedCancel: () {
                              setState(() {
                                router.maybePop();
                              });
                            },
                            onPressedApprove: () {
                              router.maybePop();
                              widget.onTap(
                                () => setState(() {
                                  _showCode = true;
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
          )
        : InkWell(
            onTap: () async {
              Clipboard.setData(
                ClipboardData(
                  text: widget.code,
                ),
              ).then((_) {
                Toast.show(L10n.tr('campaigns.copied_successfully'));
              });
            },
            child: Container(
              height: 56,
              width: double.infinity,
              color: context.pColorScheme.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.code,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: Grid.xs,
                  ),
                  const Icon(
                    Icons.content_copy_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
  }
}

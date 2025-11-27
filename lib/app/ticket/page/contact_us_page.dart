import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_bloc.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_event.dart';
import 'package:piapiri_v2/app/ticket/widget/contact_button.dart';
import 'package:piapiri_v2/app/ticket/widget/social_media_buttons.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:url_launcher/url_launcher.dart';

//Bize ulaşın ekranı
@RoutePage()
class ContactUsPage extends StatefulWidget {
  final String title;
  const ContactUsPage({super.key, required this.title});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  late AuthBloc _authBloc;
  late TicketBloc _ticketBloc;
  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();
    _ticketBloc = getIt<TicketBloc>();
    if (_authBloc.state.isLoggedIn) {
      _ticketBloc.add(
        GetRepresentativeInfoEvent(),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: widget.title,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: Grid.m,
            ),
            Text(
              L10n.tr('contact_us_info'),
              style: context.pAppStyle.labelReg16textPrimary,
            ),
            const SizedBox(height: Grid.m),
            ContactButton(
              onTap: () => _call('4447333'),
              iconPath: ImagesPath.telephone,
              text: 'bizi_arayin',
            ),
            const SizedBox(
              height: Grid.l,
            ),
            ContactButton(
              onTap: () => _sendMail(context, 'cozummerkezi@unluco.com'),
              iconPath: ImagesPath.email,
              text: 'eposta_ile_ulasin',
            ),
            const SizedBox(
              height: Grid.l,
            ),
            ContactButton(
              onTap: () {
                router.push(
                  TicketRoute(
                    title: L10n.tr('hata_bildir_v2'),
                  ),
                );
              },
              iconPath: ImagesPath.message,
              text: 'hata_bildir_v2',
            ),
            const SizedBox(
              height: Grid.xxl + Grid.l,
            ),
            Text(
              L10n.tr('social_media_text'),
              style: context.pAppStyle.interRegularBase.copyWith(
                fontSize: Grid.m,
              ),
            ),
            const SizedBox(height: Grid.m),
            const SocialMediaButtons(),
          ],
        ),
      ),
    );
  }

  _call(String phone) async {
    Uri url = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(url)) {
      launchUrl(url);
    }
  }

  _sendMail(
    BuildContext context,
    String emailUrl,
  ) async {
    final Email email = Email(
      body: '',
      subject: '',
      recipients: [emailUrl],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      PBottomSheet.showError(
        NavigatorKeys.navigatorKey.currentContext ?? context,
        content: error.toString(),
      );
    }
  }
}

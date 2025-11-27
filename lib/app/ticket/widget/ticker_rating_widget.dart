import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/ticket/model/get_tickets_model.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

//Ticket Görüşme değerlendirme
class TicketRatingWidget extends StatefulWidget {
  final GetTicketsModel ticket;
  final Function(int) onRatingSelected;

  const TicketRatingWidget({
    super.key,
    required this.ticket,
    required this.onRatingSelected,
  });

  @override
  State<TicketRatingWidget> createState() => _TicketRatingWidgetState();
}

class _TicketRatingWidgetState extends State<TicketRatingWidget> {
  int star = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          ImagesPath.checkCircle,
          width: 52,
          colorFilter: ColorFilter.mode(
            context.pColorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(
          height: Grid.m,
        ),
        Text(
          L10n.tr('evaluate_text'),
          textAlign: TextAlign.center,
          style: context.pAppStyle.labelReg16textPrimary,
        ),
        const SizedBox(
          height: Grid.xl,
        ),
        RatingBar.builder(
          initialRating: 5,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: Grid.s),
          itemBuilder: (context, _) => SvgPicture.asset(
            ImagesPath.star_full,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          onRatingUpdate: (rating) {
            setState(() {
              star = rating.toInt();
            });
            widget.onRatingSelected(star);
          },
        ),
        const SizedBox(
          height: Grid.xl,
        ),
      ],
    );
  }
}

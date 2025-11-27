import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CampaignTerms extends StatefulWidget {
  final String conditions;
  const CampaignTerms({
    super.key,
    required this.conditions,
  });

  @override
  State<CampaignTerms> createState() => _CampaignTermsState();
}

class _CampaignTermsState extends State<CampaignTerms> {
  late ExpansionTileController _controller;
  bool _isExpanded = false;
  @override
  void initState() {
    _controller = ExpansionTileController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      controller: _controller,
      onExpansionChanged: (value) => setState(
        () => _isExpanded = value,
      ),
      showTrailingIcon: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      collapsedBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      title: Row(
        children: [
          Text(
            L10n.tr('campaigns.terms'),
            style: context.pAppStyle.labelMed14textPrimary,
          ),
          const SizedBox(
            width: Grid.s,
          ),
          Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: 15,
            color: context.pColorScheme.textPrimary,
          ),
        ],
      ),
      tilePadding: EdgeInsets.zero,
      children: [
        Text(
          widget.conditions,
          style: context.pAppStyle.labelReg14textSecondary,
        ),
      ],
    );
  }
}

import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class SelectAccountTile extends StatelessWidget {
  final int index;
  final int lastIndex;
  final String selectedAccount;
  final Map accountObject;
  final Function()? onTap;

  const SelectAccountTile({
    super.key,
    required this.index,
    required this.lastIndex,
    required this.selectedAccount,
    required this.accountObject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                height: 30,
                width: 5,
                decoration: BoxDecoration(
                  color: accountObject['accountExtId'].contains(
                    selectedAccount,
                  )
                      ? context.pColorScheme.primary
                      : context.pColorScheme.transparent,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
              ),
              const SizedBox(
                width: Grid.s,
              ),
              Text(
                accountObject['accountExtId'],
                textAlign: TextAlign.start,
                style: context.pAppStyle.labelMed16textPrimary,
              ),
            ],
          ),
        ),
        index != lastIndex
            ? const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Grid.m,
                ),
                child: PDivider(),
              )
            : const SizedBox(
                height: Grid.m,
              ),
      ],
    );
  }
}

import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class TransactionHistoryAccountFilterWildget extends StatefulWidget {
  final AccountModel? selectedAccount;
  final Function(AccountModel) onSelectedAccount;
  const TransactionHistoryAccountFilterWildget(
      {super.key, required this.selectedAccount, required this.onSelectedAccount});

  @override
  State<TransactionHistoryAccountFilterWildget> createState() => _TransactionHistoryAccountFilterWildgetState();
}

class _TransactionHistoryAccountFilterWildgetState extends State<TransactionHistoryAccountFilterWildget> {
  late AccountModel? _selectedAccount;

  @override
  void initState() {
    _selectedAccount = widget.selectedAccount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: UserModel.instance.accounts
          .map(
            (e) => InkWell(
              onTap: () {
                setState(() {
                  _selectedAccount = e;
                  widget.onSelectedAccount(e);
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Grid.s + Grid.xs,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      _selectedAccount == e ? ImagesPath.selectedCircle : ImagesPath.unselectedCircle,
                      width: 15,
                      height: 15,
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                    Text(
                      e.accountId,
                      style: context.pAppStyle.labelReg14textPrimary,
                    )
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

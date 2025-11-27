import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class IpoDetailSymbolNameWidget extends StatefulWidget {
  final String symbolName;
  final VoidCallback? onTap;
  const IpoDetailSymbolNameWidget({
    super.key,
    required this.symbolName,
    this.onTap,
  });

  @override
  State<IpoDetailSymbolNameWidget> createState() => _IpoDetailSymbolNameWidgetState();
}

class _IpoDetailSymbolNameWidgetState extends State<IpoDetailSymbolNameWidget> {
  final IpoBloc _ipoBloc = getIt<IpoBloc>();

  @override
  void initState() {
    _ipoBloc.add(
      GetSymbolNameIsExistEvent(
        symbolName: widget.symbolName,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<IpoBloc, IpoState>(
        bloc: _ipoBloc,
        builder: (context, state) {
          bool symbolIsExistInDB = state.symbolName != null;

          return InkWell(
            onTap: symbolIsExistInDB ? widget.onTap : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (symbolIsExistInDB)
                  SvgPicture.asset(
                    ImagesPath.arrow_up_right,
                    width: 14,
                    height: 14,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                Text(
                  widget.symbolName,
                  textAlign: TextAlign.right,
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
              ],
            ),
          );
        });
  }
}

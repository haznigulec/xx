import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/app/ipo/pages/ipo_demanded_detail_row.dart';
import 'package:piapiri_v2/app/ipo/widgets/ipo_update_wiget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

@RoutePage()
class IpoDemandedDetailPage extends StatefulWidget {
  final IpoModel ipo;
  final VoidCallback onSuccess;
  const IpoDemandedDetailPage({
    super.key,
    required this.ipo,
    required this.onSuccess,
  });

  @override
  State<IpoDemandedDetailPage> createState() => _IpoDemandedDetailPageState();
}

class _IpoDemandedDetailPageState extends State<IpoDemandedDetailPage> {
  int unit = 1;
  late IpoBloc _ipoBloc;
  //double? _price;
  final FocusNode _focusNode = FocusNode();
  //bool _isKeyboardClosed = true;

  @override
  void initState() {
    _focusNode.addListener(_onFocusChange);
    unit = widget.ipo.unitsDemanded.toInt();

    _ipoBloc = getIt<IpoBloc>();

    _ipoBloc.add(
      GetActiveDemandsEvent(),
    );

    // bir sureligine kalacak
    // _bloc.add(
    //   GetJustActiveInfoEvent(
    //     accountId: '',
    //     callback: (ipoActiveInfoModel) {
    //       if (ipoActiveInfoModel.definitionsList != null) {
    //         if (ipoActiveInfoModel.definitionsList?.length != 0) {
    //           // seçilen halka arzın datasını bulmak için
    //           _definitionsList = ipoActiveInfoModel.definitionsList!
    //               .where(
    //                 (element) => element.name!.contains(widget.ipo.symbol!),
    //               )
    //               .toList();
    //           if (_definitionsList.isEmpty) return;
    //           for (var item in _definitionsList) {
    //             _price = item.price ?? 0;
    //             _demandedMinUnit = item.minimumNominal ?? 0.0;
    //             _amount = unit * _price!;
    //           }
    //         }
    //       }
    //     },
    //   ),
    // );

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      //_isKeyboardClosed = !_focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<IpoBloc, IpoState>(
      bloc: _ipoBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: '${L10n.tr('halka_arz')} ${L10n.tr('emir_detay')}',
            ),
            body: const Center(
              child: PLoading(),
            ),
          );
        }

        IpoDemandModel? myDemandedIpo;

        if (state.ipoDemandList != null && state.ipoDemandList!.isNotEmpty) {
          myDemandedIpo = state.ipoDemandList!
              .where(
                (element) => element.name!.contains(widget.ipo.symbol!),
              )
              .first;
        }

        return Scaffold(
          appBar: PInnerAppBar(
            title: '${L10n.tr('halka_arz')} ${L10n.tr('emir_detay')}',
          ),
          resizeToAvoidBottomInset: false,
          body: state.isLoading || state.isFailed
              ? const PLoading()
              : SingleChildScrollView(
                  child: IpoDemandedDetailRow(
                    demandedIpo: myDemandedIpo,
                  ),
                ),
          bottomNavigationBar: state.isLoading || state.isFailed
              ? const SizedBox.shrink()
              : generalButtonPadding(
                  context: context,
                  child: OrderApprovementButtons(
                    cancelButtonText: L10n.tr('sil'),
                    onPressedCancel: () => _deleteAlert(myDemandedIpo),
                    approveButtonText: L10n.tr('guncelle'),
                    onPressedApprove: () => _updatePage(myDemandedIpo),
                  )),
        );
      },
    );
  }

  void _deleteAlert(IpoDemandModel? myDemandedIpo) {
    PBottomSheet.show(
      context,
      child: Column(
        children: [
          SvgPicture.asset(
            ImagesPath.alert_circle,
            width: 52,
            height: 52,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
          StyledText(
            text: L10n.tr(
              'demanded_ipo_delete_alert',
              namedArgs: {
                'symbol': '<bold>${widget.ipo.symbol!}</bold>',
                'demand': '<orange>${L10n.tr('participation_ipo')}</orange>',
              },
            ),
            textAlign: TextAlign.center,
            style: context.pAppStyle.labelReg16textPrimary,
            tags: {
              'bold': StyledTextTag(
                style: context.pAppStyle.labelReg16textPrimary.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              'orange': StyledTextTag(
                style: context.pAppStyle.labelReg16primary,
              ),
            },
          ),
          const SizedBox(
            height: Grid.m,
          ),
          OrderApprovementButtons(
            onPressedApprove: () async {
              _ipoBloc.add(
                DemandDeleteEvent(
                  customerId: myDemandedIpo?.accountExtId!.split('-')[0] ?? '',
                  accountId: myDemandedIpo?.accountExtId!.split('-')[1] ?? '',
                  functionName: 2,
                  demandDate: DateTime.now().formatToJson(),
                  ipoId: myDemandedIpo?.ipoId! ?? '',
                  demandId: myDemandedIpo?.ipoDemandId! ?? '',
                  callback: () async {
                    widget.onSuccess();
                    _ipoBloc.add(
                      GetActiveListEvent(
                        pageNumber: 0,
                      ),
                    );

                    await router.maybePop();
                    await router.maybePop();
                    await router.maybePop();

                    router.push(
                      InfoRoute(
                        variant: InfoVariant.success,
                        message: L10n.tr('ipo.demand.deleted'),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _updatePage(IpoDemandModel? myDemandedIpo) {
    if (myDemandedIpo == null) {
      return;
    }
    PBottomSheet.show(
      context,
      title: L10n.tr('order_edit'),
      child: IpoUpdateWidget(
        myDemandedIpo: myDemandedIpo,
        symbolCompanyName: widget.ipo.companyName ?? '',
      ),
    );
  }
}

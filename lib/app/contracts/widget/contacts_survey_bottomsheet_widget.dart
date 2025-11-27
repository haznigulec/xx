import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/contracts/model/get_survey_question_model.dart';
import 'package:piapiri_v2/app/contracts/widget/contracts_textfield.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/set_answer_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ContactsSurveyBottomSheetWidget extends StatefulWidget {
  final Function(SetAnswersModel) addItemCallback;
  final String title;
  final List<AnswerOption> answerOptions;
  final int index;
  final String questionId;
  final int page;
  final List<SetAnswersModel> answersList;

  const ContactsSurveyBottomSheetWidget({
    super.key,
    required this.addItemCallback,
    required this.title,
    required this.answerOptions,
    required this.index,
    required this.questionId,
    required this.page,
    required this.answersList,
  });

  @override
  State<ContactsSurveyBottomSheetWidget> createState() => _ContactsSurveyBottomSheetWidgetState();
}

class _ContactsSurveyBottomSheetWidgetState extends State<ContactsSurveyBottomSheetWidget> {
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _selectedAnswer = widget.answersList
        .firstWhere(
          (element) => element.testQuestionId == widget.questionId,
          orElse: () => SetAnswersModel(
            testQuestionId: widget.questionId,
            answer: L10n.tr('choose'),
            description: L10n.tr('choose'),
            page: widget.page,
          ),
        )
        .description;
    widget.addItemCallback(
      SetAnswersModel(
        testQuestionId: widget.questionId,
        answer: _selectedAnswer != null && _selectedAnswer != L10n.tr('choose')
            ? widget.answerOptions.firstWhere((element) => element.description == _selectedAnswer).answerCode!
            : _selectedAnswer ?? L10n.tr('choose'),
        description: _selectedAnswer,
        page: widget.page,
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    PBottomSheet.show(
      title: widget.title,
      context,
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: widget.answerOptions.length,
        separatorBuilder: (context, index) => const PDivider(),
        itemBuilder: (context, index) => BottomsheetSelectTile(
            title: widget.answerOptions[index].description ?? '',
            isSelected: _selectedAnswer == widget.answerOptions[index].description,
            value: widget.answerOptions[index].description,
            onTap: (selectedAnswer, value) {
              setState(() {
                _selectedAnswer = selectedAnswer;
              });
              widget.addItemCallback(
                SetAnswersModel(
                  testQuestionId: widget.questionId,
                  answer: widget.answerOptions.firstWhere((element) => element.description == value).answerCode!,
                  description: widget.answerOptions.firstWhere((element) => element.description == value).description,
                  page: widget.page,
                ),
              );
              router.maybePop();
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Grid.l,
      ),
      child: GestureDetector(
        onTap: () => _showBottomSheet(context),
        child: ContractsTextfieldWidget(
          value: _selectedAnswer,
          keys: widget.title,
        ),
      ),
    );
  }
}

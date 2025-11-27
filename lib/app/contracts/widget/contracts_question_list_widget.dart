import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/model/get_survey_question_model.dart';
import 'package:piapiri_v2/app/contracts/widget/contacts_survey_bottomsheet_widget.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/custom_progress_bar.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/set_answer_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ContractsQuestionsListWidget extends StatefulWidget {
  final List<GetSurveyQuestionModel> questions;
  final List<SetAnswersModel>? answers;
  final Function(int) onChangePage;
  final int page;
  const ContractsQuestionsListWidget({
    super.key,
    required this.questions,
    required this.answers,
    required this.onChangePage,
    required this.page,
  });

  @override
  State<ContractsQuestionsListWidget> createState() => _ContractsQuestionsListWidgetState();
}

class _ContractsQuestionsListWidgetState extends State<ContractsQuestionsListWidget> {
  int maxPage = 1;
  List<SetAnswersModel> answersList = [];
  late ContractsBloc _contractsBloc;

  addItemToList(SetAnswersModel newItem) {
    int index = answersList.indexWhere(
      (element) => element.testQuestionId == newItem.testQuestionId,
    );
    if (index != -1) {
      answersList[index] = SetAnswersModel(
        testQuestionId: newItem.testQuestionId,
        answer: newItem.answer,
        description: newItem.description,
        page: newItem.page,
      );
    } else {
      answersList.add(
        SetAnswersModel(
          testQuestionId: newItem.testQuestionId,
          answer: newItem.answer,
          description: newItem.description,
          page: newItem.page,
        ),
      );
    }
  }

  @override
  void initState() {
    _contractsBloc = getIt<ContractsBloc>();
    answersList = widget.answers ?? [];
    findMaxPageInList(widget.questions);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView.builder(
            key: UniqueKey(),
            itemCount: widget.questions.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final GetSurveyQuestionModel question = widget.questions[index];
              return questionWidget(
                question,
                context,
              );
            },
          ),
        ),
        generalButtonPadding(
          context: context,
          child: PButton(
            text: L10n.tr('devam'),
            fillParentWidth: true,
            onPressed: () {
              setState(() {
                if (answersList
                    .where((element) => element.page == widget.page)
                    .any((a) => a.answer == L10n.tr('choose'))) {
                  PBottomSheet.showError(
                    context,
                    content: L10n.tr('answer_all_questions'),
                  );
                } else {
                  if (widget.page != maxPage) {
                    widget.onChangePage(widget.page + 1);
                  } else {
                    _contractsBloc.add(
                      SurveyAnswersEvent(
                        answers: answersList,
                        accountId: UserModel.instance.accountId,
                        onSuccess: (response) async {
                          await router.push(
                            ContractsSurveyResultRoute(
                              response: response,
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              });
            },
          ),
        ),
      ],
    );
  }

  int findMaxPage(GetSurveyQuestionModel surveyQuestionModel) {
    int maxPage = 0;

    if (surveyQuestionModel.questions != null) {
      for (var question in surveyQuestionModel.questions!) {
        if (question.page != null && question.page! > maxPage) {
          maxPage = question.page!;
        }
      }
    }
    if (surveyQuestionModel.subgroup != null) {
      for (var subgroup in surveyQuestionModel.subgroup!) {
        int subGroupMaxPage = findMaxPage(subgroup);
        if (subGroupMaxPage > maxPage) {
          maxPage = subGroupMaxPage;
        }
      }
    }
    return maxPage;
  }

  int findMaxPageInList(List<GetSurveyQuestionModel> questionList) {
    for (var surveyQuestionModel in questionList) {
      int currentMaxPage = findMaxPage(surveyQuestionModel);
      if (currentMaxPage > maxPage) {
        maxPage = currentMaxPage;
      }
    }

    return maxPage;
  }

  Widget questionWidget(GetSurveyQuestionModel question, BuildContext context) {
    var hasQuestion = question.questions?.any(
      (element) => element.page == widget.page,
    );
    if (question.questions != null && question.questions!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Grid.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasQuestion == true) ...[
              const SizedBox(
                height: Grid.s,
              ),
              !question.description!.contains('Risk Değeri 2')
                  ? CustomProgressBar(
                      value: widget.page / maxPage,
                      progressText: '${widget.page}/$maxPage',
                    )
                  : const SizedBox(),
              const SizedBox(
                height: Grid.xs,
              ),
              Text(
                question.description ?? '',
                textAlign: TextAlign.start,
                maxLines: 10,
                style: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.m - Grid.xxs,
                ),
              ),
              const SizedBox(
                height: Grid.m,
              ),
            ],
            ListView.builder(
              key: UniqueKey(),
              itemCount: question.questions!.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (context, innerIndex) {
                if (question.questions![innerIndex].page == widget.page) {
                  return ContactsSurveyBottomSheetWidget(
                    answersList: answersList,
                    addItemCallback: addItemToList,
                    title: L10n.tr(question.questions![innerIndex].questionId ?? ''),
                    answerOptions: question.questions![innerIndex].answerOptions!,
                    questionId: question.questions![innerIndex].questionId!,
                    index: innerIndex,
                    page: widget.page,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      );
    } else {
      NoDataWidget(message: L10n.tr('no_data'));
    }
    if (question.subgroup != null && question.subgroup!.isNotEmpty) {
      return ListView.builder(
        key: UniqueKey(),
        itemCount: question.subgroup!.length,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return questionWidget(
            question.subgroup![index],
            context,
          );
        },
      );
    } else {
      NoDataWidget(message: L10n.tr('no_data'));
    }
    return const SizedBox.shrink();
  }
}

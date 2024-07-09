import 'package:fhir_questionnaire/fhir_questionnaire.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 3/21/24.
class QuestionnaireGroupItemTitleView extends QuestionnaireItemView {
  QuestionnaireGroupItemTitleView({
    super.key,
    required super.item,
    super.enableWhenController,
  }) : super(controller: DummyController());

  @override
  State createState() => QuestionnaireDisplayItemViewState();
}

class QuestionnaireDisplayItemViewState
    extends QuestionnaireItemViewState<QuestionnaireGroupItemTitleView> {
  @override
  bool get handleControllerErrorManually => false;
  @override
  Widget buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      '${item.title}',
      style: theme.textTheme.titleLarge,
    );
  }
}

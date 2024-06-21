import 'package:fhir/r4.dart';
import 'package:fhir_questionnaire/src/model/questionnaire_item_bundle.dart';

class SubmitResult {
  final QuestionnaireResponse? _questionnaireResponse;
  final Map<int, QuestionnaireItemBundle>? _itemBundles;

  SubmitResult._(
    this._questionnaireResponse,
    this._itemBundles,
  );

  factory SubmitResult.questionnaireResponse(QuestionnaireResponse response) =>
      SubmitResult._(response, {});

  factory SubmitResult.invalidItems(Map<int, QuestionnaireItemBundle> items) =>
      SubmitResult._(null, items);

  bool get hasInvalidItems => _itemBundles?.isNotEmpty ?? false;
  bool get hasQuestionnaireResponse => _questionnaireResponse != null;
}

import 'package:fhir/r4.dart';
import 'package:fhir_questionnaire/src/model/questionnaire_item_bundle.dart';

class SubmitResult {
  final QuestionnaireResponse? _questionnaireResponse;
  final Map<int, QuestionnaireItemBundle>? _invalidItems;

  SubmitResult._(
    this._questionnaireResponse,
    this._invalidItems,
  );

  /// returns [QuestionnaireResponse]. please check if there is any first 
  /// using [hasQuestionnaireResponse] method first. will throw an exception if [hasInvalidItems] 
  /// is true
  QuestionnaireResponse get questionnaireResponse {
    if (_questionnaireResponse == null) {
      throw Exception(
        'there is no QuestionnaireResponse available and please call '
        'hasQuestionnaireResponse to check first before calling questionnaireResponse getter method',
      );
    }
    return _questionnaireResponse;
  }


  /// Returns a map of items that have invalid answers if there are any the links 
  /// the the index of each item to it. exposing both the item and its index in the list of all 
  /// available questionnaire items. please check first if there any invalidItems available 
  /// using [hasInvalidItems] method first. will throw an exception if [hasQuestionnaireResponse] 
  /// is true
  Map<int, QuestionnaireItemBundle> get invalidItems {
    if (_invalidItems == null) {
      throw Exception(
        'there is no invalid items available and please call '
        'hasInvalidItems first check if there are any before calling invalidItems getter method',
      );
    }
    return _invalidItems;
  }

  factory SubmitResult.questionnaireResponse(QuestionnaireResponse response) =>
      SubmitResult._(response, {});

  factory SubmitResult.invalidItems(Map<int, QuestionnaireItemBundle> items) =>
      SubmitResult._(null, items);

  bool get hasInvalidItems => _invalidItems?.isNotEmpty ?? false;
  bool get hasQuestionnaireResponse => _questionnaireResponse != null;
}

import 'package:collection/collection.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_questionnaire/src/logic/questionnaire_logic.dart';
import 'package:fhir_questionnaire/src/model/questionnaire_item_bundle.dart';
import 'package:fhir_questionnaire/src/presentation/localization/questionnaire_base_localization.dart';
import 'package:fhir_questionnaire/src/presentation/localization/questionnaire_localization.dart';
import 'package:fhir_questionnaire/src/presentation/utils/flutter_view_utils.dart';
import 'package:fhir_questionnaire/src/presentation/widgets/questionnaire_builder/submit_result.dart';
import 'package:flutter/widgets.dart';

class QuestionnaireController
    extends ValueNotifier<QuestionnaireControllerData> {
  QuestionnaireController({
    required this.questionnaire,
    this.onAttachmentLoaded,
    this.localizations,
    this.defaultLocalization,
    this.locale,
    this.onSubmit,
  }) : super(
          QuestionnaireControllerData(
            itemBundles: QuestionnaireLogic.buildQuestionnaireItems(
              questionnaire.item,
              onAttachmentLoaded: onAttachmentLoaded,
            ),
          ),
        ) {
    String? locale;
    try {
      locale = locale ??
          FlutterViewUtils.get().platformDispatcher.locale.languageCode;
    } catch (_) {}

    QuestionnaireLocalization.instance.init(
      defaultLocalization: defaultLocalization,
      localizations: localizations,
      locale: locale,
    );
  }

  /// Get the QuestionnaireResponse once the user taps on Submit button.
  final ValueChanged<SubmitResult>? onSubmit;

  final Questionnaire questionnaire;

  /// Indicates what should be the fallback localization if locale is not
  /// supported.
  /// Defaults to English
  final QuestionnaireBaseLocalization? defaultLocalization;

  /// Indicates the definition of extra supported localizations.
  /// By default Spanish and English are supported, but you can set
  /// other localizations on this List to be considered.
  final List<QuestionnaireBaseLocalization>? localizations;

  /// The expected locale to show, by default Platform locale is used.
  final String? locale;

  /// Necessary callback when Questionnaire has items of type = `attachment`
  /// so the logic of loading an Attachment is handled outside of the logic
  /// of QuestionnaireView
  final Future<Attachment?> Function()? onAttachmentLoaded;

  /// tries to validate the answers to each questionnaire item if there is
  /// any invalid answers they will be returned otherwise null will be returned.
  ///
  /// the result is a Map<int, QuestionnaireItemBundle> a questionnaire item bundle
  /// is mapped by its index value that it is indexed in all bundleItems that exists
  /// in this [QuestionnaireController].
  ///
  /// if [notify] is set to true the questionnaire item widgets will be notified
  /// and updated with error message.
  Map<int, QuestionnaireItemBundle> validate({bool notify = true}) {
    final map = <int, QuestionnaireItemBundle>{};

    for (var i = 0; i < value.itemBundles.length; i++) {
      final questionnaireItemBundle = value.itemBundles[i];
      if (!questionnaireItemBundle.controller.validate(notify: notify)) {
        map[i] = questionnaireItemBundle;
      }
    }

    return map;
  }

  SubmitResult submit() {
    final SubmitResult submitResult;
    final invalidItems = validate();

    if (invalidItems.isEmpty) {
      final questionnaireResponse = QuestionnaireLogic.generateResponse(
        questionnaire: questionnaire,
        itemBundles: value.itemBundles,
      );

      submitResult = SubmitResult.questionnaireResponse(questionnaireResponse);
    } else {
      submitResult = SubmitResult.invalidItems(invalidItems);
    }

    return submitResult;
  }
}

class QuestionnaireControllerData {
  QuestionnaireControllerData({
    required this.itemBundles,
  });

  final List<QuestionnaireItemBundle> itemBundles;

  QuestionnaireControllerData copyWith({
    List<QuestionnaireItemBundle>? itemBundles,
  }) =>
      QuestionnaireControllerData(
        itemBundles: itemBundles ?? this.itemBundles,
      );

  @override
  bool operator ==(Object other) =>
      other is QuestionnaireControllerData &&
      itemBundles.equals(other.itemBundles);

  @override
  int get hashCode => Object.hash(itemBundles, 10);
}

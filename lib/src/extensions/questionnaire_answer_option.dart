import 'package:collection/collection.dart';
import 'package:fhir/r4.dart';

extension QuestionnaireAnswerOptionX on QuestionnaireAnswerOption {
  String? localizedTitle(final String locale) {
    return extension_
            ?.firstWhereOrNull(
              (ext) =>
                  ext.url ==
                      FhirUri(
                          'http://hl7.org/fhir/StructureDefinition/translation') &&
                  ext.extension_?.firstWhereOrNull((e) =>
                          e.url == FhirUri('lang') &&
                          e.valueCode?.value == locale) !=
                      null,
            )
            ?.extension_
            ?.firstWhereOrNull((e) => e.url == FhirUri('content'))
            ?.valueString ??
        valueString;
  }
}

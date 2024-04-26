import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/answer_format/answer_format.dart';
import 'package:survey_kit/src/answer_format/text_choice.dart';

part 'single_choice_answer_format.g.dart';

@JsonSerializable()
class SingleChoiceAnswerFormat implements AnswerFormat {
  final List<TextChoice> textChoices;
  final TextChoice? defaultSelection;
  @JsonKey(defaultValue: false)
  final bool otherField;
  @JsonKey(defaultValue: 'Otro')
  final String otherText;

  const SingleChoiceAnswerFormat({
    required this.textChoices,
    this.defaultSelection,
    this.otherField = false,
    this.otherText = 'Otro',
  }) : super();

  factory SingleChoiceAnswerFormat.fromJson(Map<String, dynamic> json) =>
      _$SingleChoiceAnswerFormatFromJson(json);
  Map<String, dynamic> toJson() => _$SingleChoiceAnswerFormatToJson(this);
}

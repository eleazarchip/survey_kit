import 'package:survey_kit/survey_kit.dart';

import 'package:json_annotation/json_annotation.dart';

part 'iterative_custom_result.g.dart';

@JsonSerializable(explicitToJson: true)
class IterativeCustomResult extends QuestionResult<int> {
  final String customData;

  IterativeCustomResult({
    required this.customData,
    required String super.valueIdentifier,
    Identifier? identifier,
    required super.startDate,
    required super.endDate,
    required super.result})
    : super(
      id: identifier
    );

  factory IterativeCustomResult.fromJson(Map<String, dynamic> json) =>
      _$IterativeCustomResultFromJson(json);

  Map<String, dynamic> toJson() => _$IterativeCustomResultToJson(this);

  @override
  List<Object?> get props => [id, startDate, endDate, valueIdentifier, result];
}

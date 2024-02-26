// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iterative_custom_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IterativeCustomResult _$IterativeCustomResultFromJson(Map<String, dynamic> json) =>
    IterativeCustomResult(
      identifier: Identifier.fromJson(json['id'] as Map<String, dynamic>),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      valueIdentifier: json['valueIdentifier'] as String,
      result: json['result'] as int?, 
      customData: '',
    );

Map<String, dynamic> _$IterativeCustomResultToJson(IterativeCustomResult instance) =>
    <String, dynamic>{
      'id': instance.id?.toJson(),
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'result': instance.result,
      'valueIdentifier': instance.valueIdentifier,
    };

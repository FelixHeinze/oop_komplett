// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
  id: json['id'] as String,
  text: json['text'] as String,
  isDone: json['isDone'] as bool? ?? false,
);

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'isDone': instance.isDone,
};

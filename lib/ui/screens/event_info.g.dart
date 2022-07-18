// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventInfo _$EventInfoFromJson(Map<String, dynamic> json) => EventInfo(
      eventName: json['name'] as String,
      eventURL: json['url'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      duration: json['duration'] as String,
    );

Map<String, dynamic> _$EventInfoToJson(EventInfo instance) => <String, dynamic>{
      'name': instance.eventName,
      'url': instance.eventURL,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'duration': instance.duration,
    };

import 'package:json_annotation/json_annotation.dart';
part 'event_info.g.dart';

@JsonSerializable()
class EventInfo {
  @JsonKey(name: 'name')
  final String eventName;
  @JsonKey(name: 'url')
  final String eventURL;
  @JsonKey(name: 'start_time')
  final String startTime;
  @JsonKey(name: 'end_time')
  final String endTime;
  final String duration;

  EventInfo(
      {required this.eventName,
      required this.eventURL,
      required this.startTime,
      required this.endTime,
      required this.duration});
  factory EventInfo.fromJson(Map<String, dynamic> data) =>
      _$EventInfoFromJson(data);

  Map<String, dynamic> toJson() => _$EventInfoToJson(this);
}

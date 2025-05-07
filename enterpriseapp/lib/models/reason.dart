import 'package:enterpriseapp/models/subreason.dart';

class Reason {
  final int index;
  final String title;
  final List<SubReason> subReasons;

  Reason({required this.index, required this.title, required this.subReasons});

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(
      index: json['index'] as int,
      title: json['title'] as String,
      subReasons:
          (json['subReasons'] as List<dynamic>? ?? [])
              .map((e) => SubReason.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'title': title,
      'subReasons': subReasons.map((e) => e.toJson()).toList(),
    };
  }
}

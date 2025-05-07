import 'package:enterpriseapp/models/reason.dart';

class Config {
  final String? siteTitle;
  final String? qtext1;
  final String? qtext2;
  final String? altqtext1;
  final String? altqtext2;
  final String? qyn1;
  final String? qyn2;
  final String? altqyn1;
  final String? altqyn2;
  final String? thankYouTitle;
  final String? thankYouMessage;
  final String? qreason;
  final List<Reason> reasons;
  final List<Reason> altreasons;
  final String? qfname;
  final String? altqfname;
  final String? qlname;
  final String? altqlname;
  final String? altlanguage;
  final List<String>? openTimes;

  final bool askqtext1;
  final bool askqtext2;
  final bool askqyn1;
  final bool askqyn2;
  final bool askdob;
  final bool askphone;
  final bool askemail;
  final bool askreason;

  Config({
    required this.siteTitle,
    required this.qtext1,
    required this.qtext2,
    required this.altqtext1,
    required this.altqtext2,
    required this.qyn1,
    required this.qyn2,
    required this.altqyn1,
    required this.altqyn2,
    required this.qreason,
    required this.thankYouTitle,
    required this.thankYouMessage,
    required this.reasons,
    required this.altreasons,
    required this.qfname,
    required this.altqfname,
    required this.qlname,
    required this.altqlname,
    required this.askqtext1,
    required this.askqtext2,
    required this.askqyn1,
    required this.askqyn2,
    required this.askdob,
    required this.askphone,
    required this.askemail,
    required this.askreason,
    required this.openTimes,
    required this.altlanguage,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      siteTitle: json['siteTitle'] as String?,
      qtext1: json['qtext1'] as String?,
      qtext2: json['qtext2'] as String?,
      altqtext1: json['altqtext1'] as String?,
      altqtext2: json['altqtext2'] as String?,
      qyn1: json['qyn1'] as String?,
      qyn2: json['qyn2'] as String?,
      altqyn1: json['altqyn1'] as String?,
      altqyn2: json['altqyn2'] as String?,
      qreason: json['qreason'] as String?,
      thankYouTitle: json['thankYouTitle'] as String?,
      thankYouMessage: json['thankYouMessage'] as String?,
      altlanguage: json['altlanguage'] as String?,
      reasons:
          (json['reasons'] as List<dynamic>? ?? [])
              .map((e) => Reason.fromJson(e as Map<String, dynamic>))
              .toList(),
      altreasons:
          (json['altreasons'] as List<dynamic>? ?? [])
              .map((e) => Reason.fromJson(e as Map<String, dynamic>))
              .toList(),
      openTimes:
          (json['openTimes'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
      qfname: json['qfname'] as String?,
      altqfname: json['altqfname'] as String?,
      qlname: json['qlname'] as String?,
      altqlname: json['altqlname'] as String?,
      askqtext1: json['askqtext1'] as bool? ?? false,
      askqtext2: json['askqtext2'] as bool? ?? false,
      askqyn1: json['askqyn1'] as bool? ?? false,
      askqyn2: json['askqyn2'] as bool? ?? false,
      askdob: json['askdob'] as bool? ?? false,
      askphone: json['askphone'] as bool? ?? false,
      askemail: json['askemail'] as bool? ?? false,
      askreason: json['askreason'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'siteTitle': siteTitle,
      'qtext1': qtext1,
      'qtext2': qtext2,
      'altqtext1': altqtext1,
      'altqtext2': altqtext2,
      'qyn1': qyn1,
      'qyn2': qyn2,
      'altqyn1': altqyn1,
      'altqyn2': altqyn2,
      'qreason': qreason,
      'thankYouTitle': thankYouTitle,
      'thankYouMessage': thankYouMessage,
      'reasons': reasons.map((e) => e.toJson()).toList(),
      'altreasons': altreasons.map((e) => e.toJson()).toList(),
      'qfname': qfname,
      'altqfname': altqfname,
      'qlname': qlname,
      'altqlname': altqlname,
      'askqtext1': askqtext1,
      'askqtext2': askqtext2,
      'askqyn1': askqyn1,
      'askqyn2': askqyn2,
      'askdob': askdob,
      'askphone': askphone,
      'askemail': askemail,
      'askreason': askreason,
      'openTimes': openTimes,
      'altlanguage': altlanguage,
    };
  }
}

import 'package:enterpriseapp/models/config.dart';
import 'package:enterpriseapp/models/reason.dart';
import 'package:enterpriseapp/models/subreason.dart';

class ConfigDTO {
  final String? sitetitle;
  final String? qtext1;
  final String? qtext2;
  final String? altqtext1;
  final String? altqtext2;
  final String? qyn1;
  final String? qyn2;
  final String? altqyn1;
  final String? altqyn2;
  final String? reasonScreenTitle;
  final String? altReasonScreenTitle;
  final String? thankyoutitle;
  final String? thankyoumsg;
  final List<Map<String, dynamic>> altreasons;
  final List<Map<String, dynamic>> reasons;
  final String? askqtext1;
  final String? askqtext2;
  final String? askqyn1;
  final String? askqyn2;
  final String? askdob;
  final String? askphone;
  final String? askemail;
  final String? askreason;
  final String? qname;
  final String? altqname;
  final String? opentimes;
  final String? altlanguage;
  final String? altthankyoutitle;
  final String? altthankyoumsg;

  ConfigDTO({
    required this.sitetitle,
    required this.qtext1,
    required this.qtext2,
    required this.altqtext1,
    required this.altqtext2,
    required this.qyn1,
    required this.qyn2,
    required this.altqyn1,
    required this.altqyn2,
    required this.reasonScreenTitle,
    required this.altReasonScreenTitle,
    required this.thankyoutitle,
    required this.thankyoumsg,
    required this.reasons,
    required this.altreasons,
    required this.askqtext1,
    required this.askqtext2,
    required this.askqyn1,
    required this.askqyn2,
    required this.askdob,
    required this.askphone,
    required this.askemail,
    required this.askreason,
    required this.qname,
    required this.altqname,
    required this.opentimes,
    required this.altlanguage,
    required this.altthankyoutitle,
    required this.altthankyoumsg,
  });

  factory ConfigDTO.fromJson(Map<String, dynamic> json) {
    final reasons = <Map<String, dynamic>>[];
    final altreasons = <Map<String, dynamic>>[];

    for (int i = 1; i <= 16; i++) {
      final reasonKey = 'reason$i';
      final title = json[reasonKey] as String? ?? '';

      // Collect sub-reasons for this reason
      final subReasons = <String>[];
      for (int j = 1; j <= 16; j++) {
        final subReasonKey = 'r${i}sr$j';
        subReasons.add(json[subReasonKey] as String? ?? '');
      }

      reasons.add({'title': title, 'subReasons': subReasons});
    }

    for (int i = 1; i <= 16; i++) {
      final reasonKey = 'altreason$i';
      final title = json[reasonKey] as String? ?? '';

      // Collect sub-reasons for this reason
      final subReasons = <String>[];
      for (int j = 1; j <= 16; j++) {
        final subReasonKey = 'altr${i}sr$j';
        subReasons.add(json[subReasonKey] as String? ?? '');
      }

      altreasons.add({'title': title, 'subReasons': subReasons});
    }

    return ConfigDTO(
      sitetitle: json['sitetitle'] as String?,
      qtext1: json['qtext1'] as String?,
      qtext2: json['qtext2'] as String?,
      altqtext1: json['altqtext1'] as String?,
      altqtext2: json['altqtext2'] as String?,
      qyn1: json['qyn1'] as String?,
      qyn2: json['qyn2'] as String?,
      altqyn1: json['altqyn1'] as String?,
      altqyn2: json['altqyn2'] as String?,
      reasonScreenTitle: json['reasonScreenTitle'] as String?,
      altReasonScreenTitle: json['altreasonScreenTitle'] as String?,
      thankyoumsg: json['thankyoumsg'] as String?,
      thankyoutitle: json['thankyoutitle'] as String?,
      reasons: reasons,
      altreasons: altreasons,
      askqtext1: json['askqtext1'] as String?,
      askqtext2: json['askqtext2'] as String?,
      askqyn1: json['askqyn1'] as String?,
      askqyn2: json['askqyn2'] as String?,
      askdob: json['askdob'] as String?,
      askphone: json['askphone'] as String?,
      askemail: json['askemail'] as String?,
      askreason: json['askreason'] as String?,
      qname: json['qname'] as String?,
      altqname: json['altqname'] as String?,
      opentimes: json['opentimes'] as String?,
      altlanguage: json['altlanguage'] as String?,
      altthankyoutitle: json['altthankyoutitle'] as String?,
      altthankyoumsg: json['altthankyoumsg'] as String?,
    );
  }

  // Map DTO to app-specific model
  Config toModel() {
    final reasonList =
        reasons.asMap().entries.map((entry) {
          final reasonIndex = entry.key + 1;
          final reason = entry.value;
          final subReasonsRaw = reason['subReasons'] as List;
          final subReasons =
              subReasonsRaw.asMap().entries.map((subEntry) {
                final subIndex = subEntry.key + 1;
                final subTitle = subEntry.value as String;
                return SubReason(index: subIndex, title: subTitle);
              }).toList();

          return Reason(
            index: reasonIndex,
            title: reason['title'] as String,
            subReasons: subReasons,
          );
        }).toList();

    final altreasonList =
        altreasons.asMap().entries.map((entry) {
          final reasonIndex = entry.key + 1;
          final reason = entry.value;
          final subReasonsRaw = reason['subReasons'] as List;
          final subReasons =
              subReasonsRaw.asMap().entries.map((subEntry) {
                final subIndex = subEntry.key + 1;
                final subTitle = subEntry.value as String;
                return SubReason(index: subIndex, title: subTitle);
              }).toList();

          return Reason(
            index: reasonIndex,
            title: reason['title'] as String,
            subReasons: subReasons,
          );
        }).toList();

    return Config(
      siteTitle: sitetitle,
      qtext1: qtext1,
      qtext2: qtext2,
      altqtext1: altqtext1,
      altqtext2: altqtext2,
      qyn1: qyn1,
      qyn2: qyn2,
      altqyn1: altqyn1,
      altqyn2: altqyn2,
      qreason: reasonScreenTitle,
      altqreason: altReasonScreenTitle,
      thankYouTitle: thankyoutitle,
      thankYouMessage: thankyoumsg,
      altThankYouTitle: altthankyoutitle,
      altThankYouMessage: altthankyoumsg,
      reasons: reasonList,
      altreasons: altreasonList,
      qfname: qname,
      altqfname: altqname,
      altlanguage: altlanguage,
      qlname: '',
      altqlname: '',
      askqtext1: askqtext1 == '1',
      askqtext2: askqtext2 == '1',
      askqyn1: askqyn1 == '1',
      askqyn2: askqyn2 == '1',
      askdob: askdob == '1',
      askphone: askemail == '1',
      askemail: askemail == '1',
      askreason: askreason == '1',
      openTimes:
          (opentimes ?? '')
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList(),
    );
  }
}

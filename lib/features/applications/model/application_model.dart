import '../../../core/widgets/app_badge.dart';

class ApplicationModel {
  final String id;
  final String applicant;
  final String district;
  final int treeCount;
  final String compensation;
  final String stage;
  final BadgeType stageClass;
  final String date;
  final String sla;
  final BadgeType slaClass;

  ApplicationModel({
    required this.id,
    required this.applicant,
    required this.district,
    required this.treeCount,
    required this.compensation,
    required this.stage,
    required this.stageClass,
    required this.date,
    required this.sla,
    required this.slaClass,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] as String,
      applicant: json['applicant'] as String,
      district: json['district'] as String,
      treeCount: json['tree_count'] as int,
      compensation: json['compensation'] as String,
      stage: json['stage'] as String,
      stageClass: _parseBadgeType(json['stage_class']),
      date: json['date'] as String,
      sla: json['sla'] as String,
      slaClass: _parseBadgeType(json['sla_class']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicant': applicant,
      'district': district,
      'tree_count': treeCount,
      'compensation': compensation,
      'stage': stage,
      'stage_class': stageClass.name,
      'date': date,
      'sla': sla,
      'sla_class': slaClass.name,
    };
  }

  static BadgeType _parseBadgeType(dynamic value) {
    if (value == null) return BadgeType.info;
    return BadgeType.values.firstWhere(
      (e) => e.name == value.toString(),
      orElse: () => BadgeType.info,
    );
  }
}

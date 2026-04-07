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
}

class FilterModel {
  final String id;
  final String keyword;
  final String location;
  final String experienceLevel;
  final String workType;
  final String jobType;
  final bool easyApply;

  FilterModel({
    required this.id,
    required this.keyword,
    required this.location,
    required this.experienceLevel,
    required this.workType,
    required this.jobType,
    required this.easyApply,
  });
}

class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final String url;
  final double matchScore;
  final String matchReasoning;
  final String coverLetter;
  final DateTime postedDate;
  final DateTime scrapedDate;
  final String jobType;
  final String workType;
  final bool easyApply;
  final String status;
  final DateTime? appliedDate;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.url,
    required this.matchScore,
    required this.matchReasoning,
    required this.coverLetter,
    required this.postedDate,
    required this.scrapedDate,
    required this.jobType,
    required this.workType,
    required this.easyApply,
    required this.status,
    this.appliedDate,
  });
}

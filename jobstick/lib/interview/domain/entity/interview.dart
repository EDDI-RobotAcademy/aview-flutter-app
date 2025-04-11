class Interview {
  final int id;
  final String title;
  final String companyName;
  final String jobTitle;
  final String jobCategory;
  final String createDate;

  Interview({
    this.id = 0, // 기본값 설정
    this.title = 'No Title',
    this.companyName = 'Unknown Company',
    this.jobTitle = 'Unknown Job Title',
    this.jobCategory = 'Unknown Category',
    this.createDate = 'Unknown',
  });

  Map<String, dynamic> toJson() {
    return {
      'interviewId': id,
      'title': title,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'jobCategory': jobCategory,
      'createDate': createDate,
    };
  }

  factory Interview.fromJson(Map<String, dynamic> json) {
    try {
      return Interview(
        id: json['interviewId'] ?? 0,
        title: json['title'] ?? 'No Title',
        companyName: json['companyName'] ?? 'Unknown Company',
        jobTitle: json['jobTitle'] ?? 'Unknown Job Title',
        jobCategory: json['jobCategory'] ?? 'Unknown Category',
        createDate: json['createDate'] ?? 'Unknown',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  String toString() {
    return 'Interview(id: $id, title: $title, companyName: $companyName, jobTitle: $jobTitle, jobCategory: $jobCategory, createDate: $createDate)';
  }
}

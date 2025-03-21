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

  // JSON 데이터를 Interview 객체로 변환
  factory Interview.fromJson(Map<String, dynamic> json) {
    try {
      print('JSON 변환 시작: $json');

      return Interview(
        id: json['interviewId'] ?? 0,
        title: json['title'] ?? 'No Title',
        companyName: json['companyName'] ?? 'Unknown Company',
        jobTitle: json['jobTitle'] ?? 'Unknown Job Title',
        jobCategory: json['jobCategory'] ?? 'Unknown Category',
        createDate: json['createDate'] ?? 'Unknown',
      );
    } catch (e) {
      print('JSON 파싱 중 오류: $json, Error: $e');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'Interview(id: $id, title: $title, companyName: $companyName, jobTitle: $jobTitle, jobCategory: $jobCategory, createDate: $createDate)';
  }
}

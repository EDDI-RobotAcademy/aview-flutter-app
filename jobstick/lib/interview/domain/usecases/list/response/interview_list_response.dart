import '../../../entity/interview.dart';

class InterviewListResponse {
  final List<Interview> interviewList;
  final int totalItems;
  final int totalPages;

  InterviewListResponse({
    required this.interviewList,
    required this.totalItems,
    required this.totalPages,
  });
}
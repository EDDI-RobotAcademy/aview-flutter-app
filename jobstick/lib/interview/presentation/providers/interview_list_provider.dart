import 'package:flutter/cupertino.dart';

import '../../domain/entity/interview.dart';
import '../../domain/usecases/list/list_interview_use_case.dart';

class InterviewListProvider with ChangeNotifier {
  final ListInterviewUseCase listInterviewUseCase;

  List<Interview> interviewList = [];
  String message = '';
  bool isLoading = false;

  int totalItems = 0;
  int totalPages = 0;
  int currentPage = 1;

  InterviewListProvider({
    required this.listInterviewUseCase,
  });

  Future<void> listInterview(int page, int perPage) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final interviewListResponse =
      await listInterviewUseCase.call(page, perPage);

      if (interviewListResponse.interviewList.isEmpty) {
        message = '등록된 모의 면접이 없습니다';
      } else {
        interviewList = interviewListResponse.interviewList;
        totalItems = interviewListResponse.totalItems;
        totalPages = interviewListResponse.totalPages;
        currentPage = page;
      }
    } catch (e) {
      message = '모의 면접 목록을 가져오는 중 문제가 발생했습니다';
    }

    isLoading = false;
    notifyListeners();
  }

  void changePage(int page, int perPage) {
    listInterview(page, perPage);
  }

  void updateInterview(Interview updatedInterview) {
    final index =
    interviewList.indexWhere((interview) => interview.id == updatedInterview.id);
    if (index != -1) {
      interviewList[index] = updatedInterview;
      notifyListeners();
    }
  }
}

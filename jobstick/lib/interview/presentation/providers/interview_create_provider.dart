import 'package:flutter/material.dart';
import '../../domain/entity/interview.dart';
import '../../domain/usecases/create/create_interview_use_case.dart';

class InterviewCreateProvider extends ChangeNotifier {
  final CreateInterviewUseCase createInterviewUseCase;

  InterviewCreateProvider({required this.createInterviewUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> createInterview(Interview interview) async {
    _isLoading = true;
    notifyListeners();

    try {
      await createInterviewUseCase.createInterview(interview);
      _errorMessage = null; // 성공시 에러 메시지 초기화
    } catch (e) {
      _errorMessage = '면접 설정 실패: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

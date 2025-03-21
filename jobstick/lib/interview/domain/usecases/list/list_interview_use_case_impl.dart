import 'package:jobstick/interview/domain/usecases/list/response/interview_list_response.dart';
import '../../../infrastructures/repository/interview_repository.dart';
import 'list_interview_use_case.dart';

class ListInterviewUseCaseImpl implements ListInterviewUseCase {
  final InterviewRepository interviewRepository;

  // 생성자에서 인터뷰 리포지토리 의존성 주입
  ListInterviewUseCaseImpl(this.interviewRepository);

  @override
  Future<InterviewListResponse> call(int page, int perPage) async {
    try {
      // 인터뷰 목록을 리포지토리에서 가져옴
      final InterviewListResponse response = await interviewRepository.listInterview(page, perPage);

      return response;
    } catch (error) {
      // 에러 처리
      rethrow;
    }
  }
}

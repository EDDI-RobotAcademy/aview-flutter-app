import 'package:jobstick/interview/infrastructures/repository/interview_repository_impl.dart';

import '../../entity/interview.dart';
import 'create_interview_use_case.dart';

class CreateInterviewUseCaseImpl implements CreateInterviewUseCase {
  final InterviewRepositoryImpl interviewRepository;

  CreateInterviewUseCaseImpl(this.interviewRepository);

  @override
  Future<void> createInterview(Interview interview) async {
    try {
      // Call the repository to save the interview
      // await interviewRepository.createInterview(interview);
    } catch (e) {
      // Handle error in the interview creation process
      throw Exception('Failed to create interview: $e');
    }
  }
}

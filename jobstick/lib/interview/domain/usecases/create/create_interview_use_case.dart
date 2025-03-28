import '../../entity/interview.dart';

abstract class CreateInterviewUseCase {
  Future<void> createInterview(Interview interview);
}

import '../../domain/usecases/list/response/interview_list_response.dart';

abstract class InterviewRepository {
  Future<InterviewListResponse> listInterview(int page, int perPage);
}

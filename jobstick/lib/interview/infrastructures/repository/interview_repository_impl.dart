import '../../domain/entity/interview.dart';
import '../../domain/usecases/list/response/interview_list_response.dart';
import '../data_sources/interview_remote_data_source.dart';
import 'interview_repository.dart';

class InterviewRepositoryImpl implements InterviewRepository {
  final InterviewRemoteDataSource remoteDataSource;

  InterviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<InterviewListResponse> listInterview(int page, int perPage) async {
    final interviewListResponse = await remoteDataSource.listInterview(page, perPage);

    return interviewListResponse;
  }
}

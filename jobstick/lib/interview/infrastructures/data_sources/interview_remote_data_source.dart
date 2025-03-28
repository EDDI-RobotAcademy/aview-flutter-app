import 'dart:convert';
import 'package:jobstick/interview/domain/entity/interview.dart';
import 'package:jobstick/interview/domain/usecases/list/response/interview_list_response.dart';
import 'package:http/http.dart' as http;

class InterviewRemoteDataSource {
  final String baseUrl;

  InterviewRemoteDataSource(this.baseUrl);

  Future<InterviewListResponse> listInterview(int page, int perPage) async {
    final parsedUri = Uri.parse('$baseUrl/interview/list?page=$page&perPage=$perPage');

    final interviewListResponse = await http.get(parsedUri);

    if (interviewListResponse.statusCode == 200) {
      final data = json.decode(interviewListResponse.body);

      List<Interview> interviewList = (data['dataList'] as List)
          .map((data) => Interview(
        id: data['id'] ?? 0,  // id 추가
        title: data['title'] ?? 'No Title',  // title 추가
        companyName: data['companyName'] ?? 'Unknown',
        jobTitle: data['jobTitle'] ?? 'Unknown',
        jobCategory: data['jobCategory'] ?? 'Unknown',
        createDate: data['createDate'] ?? 'Unknown',  // createDate 추가
      ))
          .toList();

      int totalItems = parseInt(data['totalItems']);
      int totalPages = parseInt(data['totalPages']);

      return InterviewListResponse(
        interviewList: interviewList,
        totalItems: totalItems,
        totalPages: totalPages,
      );
    } else {
      throw Exception('인터뷰 목록 조회 실패');
    }
  }

  int parseInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return value ?? 0;
  }
}

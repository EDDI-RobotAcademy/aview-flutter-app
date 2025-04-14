import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/entity/blog_post.dart';
import '../../domain/usecases/list/response/blog_post_list_response.dart';

class BlogPostRemoteDataSource {
  final String baseUrl;

  BlogPostRemoteDataSource(this.baseUrl);
  
  Future<BlogPostListResponse> listBlogPost(int page, int perPage) async {
    final parsedUri =
      Uri.parse('$baseUrl/blog-post/list?page=$page&perPage=$perPage');

    final boardListResponse = await http.get(parsedUri);

    if (boardListResponse.statusCode == 200) {
      final data = json.decode(boardListResponse.body);

      List<BlogPost> blogPostList = (data['dataList'] as List)
        .map((data) => BlogPost(
          id: data['id'] ?? 0,
          title: data['title'] ?? 'Untitled',
          content: '',
          nickname: data['nickname'] ?? '익명',
          createDate: data['createDate'] ?? 'Unknown'
        )
      )
      .toList();

      int totalItems = parseInt(data['totalItems']);
      int totalPages = parseInt(data['totalPages']);
      
      return BlogPostListResponse(
        blogPostList: blogPostList,
        totalItems: totalItems, 
        totalPages: totalPages
      );
    } else {
      throw Exception('게시물 리스트 조회 실패');
    }
  }

  Future<String> uploadBlogPost(String title, String compressedHtmlContent, String userToken) async {
    print("BlogPostRemoteDataSource uploadBlogPost() -> compressedHtmlContent: $compressedHtmlContent");

    final response = await http.post(
      Uri.parse('$baseUrl/blog-post/upload'),
      headers: {
        'Content-Type': 'application/json', // JSON Content-Type 추가
      },
      body: jsonEncode({
        'content': compressedHtmlContent,
        'title': title,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['filename']; // UUID.html 반환
    } else {
      throw Exception('❌ Failed to upload content: ${response.body}');
    }
  }

  Future<BlogPost> create(String title, String content, String userToken) async {
    final url = Uri.parse('$baseUrl/blog-post/create');
    final response = await http.post(
      url,
      body: {
        'title': title,
        'content': content,
        'userToken': userToken,
      }
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return BlogPost(
        id: data['data']['id'] ?? 0,
        title: data['data']['title'] ?? 'Untitled',
        content: data['data']['content'] ?? '',
        nickname: data['data']['writerNickname'] ?? 'Anonymouse',
        createDate: data['data']['createDate'] ?? 'Unknown',
      );
    } else {
      throw Exception("게시물 생성 실패");
    }
  }

  Future<BlogPost?> fetchBlogPost(int blogPostId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/blog-post/read/$blogPostId'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return BlogPost.fromJson(data);
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> uploadBlogPostImage(String imageContent, String userToken) async {
    print("BlogPostRemoteDataSource uploadBlogPostImage() -> imageContent: $imageContent");

    final response = await http.post(
      Uri.parse('$baseUrl/blog-post/upload-image'),
      headers: {
        'Content-Type': 'application/json', // JSON Content-Type 추가
      },
      body: jsonEncode({
        'image': imageContent, // base64로 인코딩된 이미지 데이터
        'userToken': userToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['imageUrl']; // 이미지 URL 반환
    } else {
      throw Exception('❌ Failed to upload image: ${response.body}');
    }
  }

  Future<BlogPost> updateBlogPost(
      int blogPostId, String title, String content, String userToken) async {
    final url = Uri.parse('$baseUrl/blog-post/modify/$blogPostId');
    final response = await http.put(
      url,
      body: {
        'title': title,
        'content': content,
        'userToken': userToken,
      },
    );

    if (response.statusCode == 200) {
      // 서버 응답을 파싱하여 수정된 게시글 반환
      final data = json.decode(response.body);
      final blogPostId = data['blogPostId'];

      return BlogPost(
        id: data['blogPostId'] ?? blogPostId, // boardId가 응답에 없으면 기존 값 사용
        title: data['title'] ?? title, // 응답 없으면 기존 값 사용
        content: data['content'] ?? content,
        nickname: data['writerNickname'] ?? 'Anonymous',
        createDate: data['createDate'] ?? 'Unknown',
      );
    } else {
      throw Exception('Failed to update the board: ${response.body}');
    }
  }

  Future<void> deleteBlogPost(int blogPostId, String userToken) async {
    final url = Uri.parse('$baseUrl/blog-post/delete/$blogPostId');

    final response = await http.delete(
      url,
      body: {
        'userToken': userToken,
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('게시글 삭제 실패');
    }
  }

  int parseInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return value ?? 0;
  }
}
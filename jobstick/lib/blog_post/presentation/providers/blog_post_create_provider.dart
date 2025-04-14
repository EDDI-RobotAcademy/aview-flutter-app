import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../../../utility/aws_s3_utility.dart';
import '../../domain/entity/blog_post.dart';
import '../../domain/usecases/create/create_blog_post_use_case.dart';
import '../../domain/usecases/upload/upload_blog_post_use_case.dart';

class BlogPostCreateProvider with ChangeNotifier {
  final CreateBlogPostUseCase createBlogPostUseCase;
  final UploadBlogPostUseCase uploadBlogPostUseCase;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  BlogPostCreateProvider({
    required this.createBlogPostUseCase,
    required this.uploadBlogPostUseCase,
  });

  bool isLoading = false;
  String message = '';

  Future<BlogPost?> createBlogPost(String title, String compressedHtml) async {
    isLoading = true;
    notifyListeners();

    try {
      final userToken = await secureStorage.read(key: 'userToken');

      if (userToken == null) {
        message = '로그인 상태가 아니므로 로그인을 먼저 해주세요.';
        isLoading = false;
        notifyListeners();
        return null;
      }

      // 1. HTML을 S3에 업로드하여 UUID.html 파일명 받기
      final contentHtmlFile = await uploadBlogPostUseCase.execute(title, compressedHtml, userToken);
      print("contentHtmlFile: $contentHtmlFile");

      // 2. UUID.html을 이용해 블로그 포스트 생성
      final blogPost = await createBlogPostUseCase.execute(title, contentHtmlFile, userToken);
      print("blogPost: $blogPost");

      return blogPost;
    } catch (e) {
      message = '게시물 생성에 실패했습니다. 오류: $e';
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Delta JSON -> HTML 변환
  String convertDeltaToHtml(List<dynamic> deltaJson) {
    final converter = QuillDeltaToHtmlConverter(List.castFrom(deltaJson));
    return converter.convert();
  }
}

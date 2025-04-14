import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../domain/entity/blog_post.dart';
import '../../domain/usecases/list/list_blog_post_use_case.dart';

class BlogPostListProvider with ChangeNotifier {
  // final S3Service _s3Service = S3Service();
  final ListBlogPostUseCase listBlogPostUseCase;

  List<BlogPost> blogPostList = [];
  String message = '';
  bool isLoading = false;

  int totalItems = 0;
  int totalPages = 0;
  int currentPage = 1;

  BlogPostListProvider({
    required this.listBlogPostUseCase
  });

  Future<void> listBlogPosts(int page, int perPage) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final boardListResponse = await listBlogPostUseCase.call(page, perPage);

      if (boardListResponse.blogPostList.isEmpty) {
        message = '등록된 내용이 없습니다';
      } else {
        blogPostList = boardListResponse.blogPostList;
        totalItems = boardListResponse.totalItems;
        totalPages = boardListResponse.totalPages;
        currentPage = page;
      }
    } catch (e) {
      message = '게시글을 가져오는 중 문제가 발생했습니다';
    }

    isLoading = false;
    notifyListeners();
  }
}

import 'package:jobstick/blog_post/domain/usecases/list/response/blog_post_list_response.dart';

import '../../../infrastructures/repository/blog_post_repository.dart';
import 'list_blog_post_use_case.dart';

class ListBlogPostUseCaseImpl implements ListBlogPostUseCase {
  final BlogPostRepository blogPostRepository;

  ListBlogPostUseCaseImpl(this.blogPostRepository);

  @override
  Future<BlogPostListResponse> call(int page, int perPage) async {
    try {
      final BlogPostListResponse response =
        await blogPostRepository.requestList(page, perPage);

      return response;
    } catch (e) {
      throw Exception('Failed to fetch post');
    }
  }
}
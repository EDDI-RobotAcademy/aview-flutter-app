import 'package:jobstick/blog_post/domain/usecases/list/response/blog_post_list_response.dart';

abstract class ListBlogPostUseCase {
  Future<BlogPostListResponse> call(int page, int perPage);
}
import '../../domain/entity/blog_post.dart';
import '../../domain/usecases/list/response/blog_post_list_response.dart';

abstract class BlogPostRepository {
  Future<BlogPostListResponse> requestList(int page, int perPage);
  Future<String> uploadBlogPost(String title, String compressedHtmlContent, String userToken);
  Future<BlogPost> create(String title, String content, String userToken);
  Future<BlogPost?> readBlogPost(int id);
  Future<String> uploadBlogPostImage(String imageContent, String userToken);
  Future<BlogPost?> updateBlogPost(
      int blogPostId, String title, String content, String userToken);
  Future<void> deleteBlogPost(int id, String userToken);
}
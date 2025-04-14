import '../../entity/blog_post.dart';

abstract class UpdateBlogPostUseCase {
  Future<BlogPost?> execute(
      int blogPostId, String title, String content, String userToken);
}

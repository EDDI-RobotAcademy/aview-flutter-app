import '../../entity/blog_post.dart';

abstract class ReadBlogPostUseCase {
  Future<BlogPost?> execute(int blogPostId);
}
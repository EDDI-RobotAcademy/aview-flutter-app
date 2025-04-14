import 'package:jobstick/blog_post/domain/entity/blog_post.dart';

abstract class CreateBlogPostUseCase {
  Future<BlogPost> execute(String title, String content, String userToken);
}

import 'package:jobstick/blog_post/domain/usecases/read/read_blog_post_usecase.dart';

import '../../../infrastructures/repository/blog_post_repository.dart';
import '../../entity/blog_post.dart';

class ReadBlogPostUseCaseImpl implements ReadBlogPostUseCase {
  final BlogPostRepository blogPostRepository;

  ReadBlogPostUseCaseImpl(
    this.blogPostRepository
  );

  @override
  Future<BlogPost?> execute(int blogPostId) async {
    try {
      print("blogPostId: ${blogPostId}");
      final blogPost = await blogPostRepository.readBlogPost(blogPostId);
      print("ReadBlogPostUseCaseImpl execute() -> blogPost: ${blogPost}");
      return blogPost;
    } catch (e) {
      return null;
    }
  }
}
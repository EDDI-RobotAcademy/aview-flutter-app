import '../../../infrastructures/repository/blog_post_repository.dart';
import '../../entity/blog_post.dart';
import 'create_blog_post_use_case.dart';

class CreateBlogPostUseCaseImpl implements CreateBlogPostUseCase {
  final BlogPostRepository blogPostRepository;

  CreateBlogPostUseCaseImpl(this.blogPostRepository);

  @override
  Future<BlogPost> execute(String title, String content, String userToken) async {
    try {
      final blogPost = await blogPostRepository.create(title, content, userToken);
      return blogPost;
    } catch (e) {
      throw Exception('게시물 생성 실패');
    }
  }
}
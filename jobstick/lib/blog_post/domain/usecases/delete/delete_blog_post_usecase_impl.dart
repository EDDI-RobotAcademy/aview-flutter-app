import '../../../infrastructures/repository/blog_post_repository.dart';
import 'delete_blog_post_usecase.dart';

class DeleteBlogPostUseCaseImpl implements DeleteBlogPostUseCase {
  final BlogPostRepository blogPostRepository;

  DeleteBlogPostUseCaseImpl(this.blogPostRepository);

  @override
  Future<void> execute(int blogPostId, String userToken) async {
    return await blogPostRepository.deleteBlogPost(blogPostId, userToken);
  }
}

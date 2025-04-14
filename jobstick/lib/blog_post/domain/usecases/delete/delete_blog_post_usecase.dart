abstract class DeleteBlogPostUseCase {
  Future<void> execute(int blogPostId, String userToken);
}

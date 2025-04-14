import 'package:jobstick/blog_post/domain/usecases/upload/upload_blog_post_use_case.dart';

import '../../../infrastructures/repository/blog_post_repository.dart';

class UploadBlogPostUseCaseImpl implements UploadBlogPostUseCase {
  final BlogPostRepository blogPostRepository;

  UploadBlogPostUseCaseImpl(this.blogPostRepository);

  @override
  Future<String> execute(String title, String compressedHtmlContent, String userToken) {
    print("UploadBlogPostUseCaseImpl execute() -> compressedHtmlContent: $compressedHtmlContent");
    return blogPostRepository.uploadBlogPost(title, compressedHtmlContent, userToken);
  }
}

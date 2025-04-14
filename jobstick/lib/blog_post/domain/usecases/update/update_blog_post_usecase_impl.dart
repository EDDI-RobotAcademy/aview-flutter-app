import 'package:jobstick/blog_post/domain/usecases/update/update_blog_post_usecase.dart';
import 'package:jobstick/board/domain/usecases/update/update_board_usecase.dart';

import '../../../infrastructures/repository/blog_post_repository.dart';
import '../../entity/blog_post.dart';

class UpdateBlogPostUseCaseImpl implements UpdateBlogPostUseCase {
  final BlogPostRepository blogPostRepository;

  UpdateBlogPostUseCaseImpl(this.blogPostRepository);

  @override
  Future<BlogPost?> execute(
      int blogPostId, String title, String content, String userToken) async {
    try {
      final updatedBlogPost =
          await blogPostRepository.updateBlogPost(blogPostId, title, content, userToken);

      if (updatedBlogPost == null) {
        throw Exception('Updated blogPost is null');
      }

      print(
          "UpdateBlogPostUseCaseImpl Updated BlogPost from UseCase: ${updatedBlogPost.toJson()}");
      return updatedBlogPost;
    } catch (e) {
      print("Error in UpdateBoardUseCase: $e");
      rethrow; // 에러를 다시 던져서 상위에서 처리하도록 함
    }
  }
}

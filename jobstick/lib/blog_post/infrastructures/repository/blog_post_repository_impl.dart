import '../../domain/entity/blog_post.dart';
import '../../domain/usecases/list/response/blog_post_list_response.dart';
import '../data_sources/blog_post_remote_data_source.dart';
import 'blog_post_repository.dart';

class BlogPostRepositoryImpl implements BlogPostRepository {
  final BlogPostRemoteDataSource blogPostRemoteDataSource;

  BlogPostRepositoryImpl(this.blogPostRemoteDataSource);

  @override
  Future<BlogPostListResponse> requestList(int page, int perPage) async {
    final blogPostListResponse =
    await blogPostRemoteDataSource.listBlogPost(page, perPage);
    print("BlogPostRepositoryImpl requestList() -> blogPostListResponse: $blogPostListResponse");

    return blogPostListResponse;
  }

  @override
  Future<String> uploadBlogPost(String title, String compressedHtmlContent, String userToken) {
    print("BlogPostRepositoryImpl uploadBlogPost() -> compressedHtmlContent: $compressedHtmlContent");
    return blogPostRemoteDataSource.uploadBlogPost(title, compressedHtmlContent, userToken);
  }

  @override
  Future<BlogPost> create(String title, String content, String userToken) async {
    try {
      final blogPost = await blogPostRemoteDataSource.create(title, content, userToken);
      return blogPost;
    } catch (e) {
      print("오류 발생: $e");
      throw Exception('게시물 생성 실패');
    }
  }

  @override
  Future<BlogPost?> readBlogPost(int id) async {
    try {
      final blogPost = await blogPostRemoteDataSource.fetchBlogPost(id);
      print("readBlogPost() -> blogPost: ${blogPost}");
      return blogPost;
    } catch (e) {
      throw Exception("게시물 읽기 실패");
    }
  }

  @override
  Future<String> uploadBlogPostImage(String imageContent, String userToken) {
    print("BlogPostRepositoryImpl uploadBlogPostImage() -> imageContent: $imageContent");
    return blogPostRemoteDataSource.uploadBlogPostImage(imageContent, userToken);
  }

  @override
  Future<BlogPost?> updateBlogPost(
      int blogPostId, String title, String content, String userToken) async {
    try {
      final updatedBlogPost = await blogPostRemoteDataSource.updateBlogPost(
          blogPostId, title, content, userToken);

      if (updatedBlogPost == null) {
        throw Exception("Invalid response or missing data field.");
      }

      return updatedBlogPost;
    } catch (e) {
      print('Error in updateBoard repository: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteBlogPost(int id, String userToken) async {
    try {
      return await blogPostRemoteDataSource.deleteBlogPost(id, userToken);
    } catch (e) {
      throw Exception('게시글 삭제 실패: $e');
    }
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../utility/aws_s3_utility.dart';
import '../../domain/entity/blog_post.dart';
import '../../domain/usecases/delete/delete_blog_post_usecase.dart';
import '../../domain/usecases/read/read_blog_post_usecase.dart';

class BlogPostReadProvider with ChangeNotifier {
  final ReadBlogPostUseCase readBlogPostUseCase;
  final DeleteBlogPostUseCase deleteBlogPostUseCase;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final int blogPostId;

  String? _s3Filename;
  BlogPost? _blogPost;
  String? _error;
  bool _isLoading = false;

  int totalItems = 0;
  int totalPages = 0;
  int currentPage = 1;

  BlogPostReadProvider({
    required this.readBlogPostUseCase,
    required this.deleteBlogPostUseCase,
    required this.blogPostId,
  });

  String? get s3Filename => _s3Filename;
  BlogPost? get blogPost => _blogPost;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> fetchBlogPost() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _blogPost = await readBlogPostUseCase.execute(blogPostId);

      final fileName = _blogPost!.content!;
      final fileContent = await AwsS3Utility.downloadFile('blog-post', fileName);

      if (fileContent != null) {
        // 다운로드한 HTML 또는 다른 파일을 처리
        _s3Filename = _blogPost?.content;
        _blogPost?.content = fileContent; // 업데이트된 콘텐츠로 덮어쓰기
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateBlogPost(BlogPost updatedBlogPost) {
    if (_blogPost?.id == updatedBlogPost.id) {
      print("read provider update");
      _blogPost = updatedBlogPost;
      notifyListeners();
    }
  }

  Future<void> deleteBlogPost() async {
    try {
      if (blogPost != null) {
        final userToken = await secureStorage.read(key: 'userToken');
        if (userToken == null) {
          throw Exception('User is not logged in.');
        }

        print("delete fileName: ${_s3Filename}");
        print("delete blogPostId: ${blogPost!.id}");
        // await AwsS3Utility.deleteFile('blog-post', _s3Filename!);

        await deleteBlogPostUseCase.execute(blogPost!.id, userToken);

        _blogPost = null;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }
}
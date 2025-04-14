import 'package:jobstick/blog_post/domain/usecases/upload/upload_blog_post_use_case_impl.dart';
import 'package:jobstick/blog_post/presentation/providers/blog_post_create_provider.dart';
import 'package:jobstick/blog_post/presentation/providers/blog_post_list_provider.dart';
import 'package:jobstick/blog_post/presentation/providers/blog_post_modify_provider.dart';
import 'package:jobstick/blog_post/presentation/providers/blog_post_read_provider.dart';
import 'package:jobstick/blog_post/presentation/ui/blog_post_create_page.dart';
import 'package:jobstick/blog_post/presentation/ui/blog_post_list_page.dart';
import 'package:jobstick/blog_post/presentation/ui/blog_post_modify_page.dart';
import 'package:jobstick/blog_post/presentation/ui/blog_post_read_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'domain/usecases/create/create_blog_post_use_case_impl.dart';
import 'domain/usecases/delete/delete_blog_post_usecase_impl.dart';
import 'domain/usecases/list/list_blog_post_use_case_impl.dart';
import 'domain/usecases/read/read_blog_post_usecase_impl.dart';
import 'domain/usecases/update/update_blog_post_usecase_impl.dart';
import 'infrastructures/data_sources/blog_post_remote_data_source.dart';
import 'infrastructures/repository/blog_post_repository_impl.dart';

class BlogPostModule {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  static final blogPostRemoteDataSource = BlogPostRemoteDataSource(baseUrl);
  static final blogPostRepository = BlogPostRepositoryImpl(blogPostRemoteDataSource);

  static final listBlogPostUseCase = ListBlogPostUseCaseImpl(blogPostRepository);
  static final createBlogPostUseCase = CreateBlogPostUseCaseImpl(blogPostRepository);
  static final uploadBlogPostUseCase = UploadBlogPostUseCaseImpl(blogPostRepository);
  static final readBlogPostUseCase = ReadBlogPostUseCaseImpl(blogPostRepository);
  static final updateBlogPostUseCase = UpdateBlogPostUseCaseImpl(blogPostRepository);
  static final deleteBlogPostUseCase = DeleteBlogPostUseCaseImpl(blogPostRepository);

  static List<SingleChildWidget> provideCommonProviders () {
    return [
      Provider(create: (_) => listBlogPostUseCase),
      Provider(create: (_) => createBlogPostUseCase),
      Provider(create: (_) => uploadBlogPostUseCase),
      Provider(create: (_) => readBlogPostUseCase),
      Provider(create: (_) => updateBlogPostUseCase),
      Provider(create: (_) => deleteBlogPostUseCase),
    ];
  }

  static Widget provideBlogPostListPage() {
    return MultiProvider(
      providers: [
        ...provideCommonProviders(),
        ChangeNotifierProvider(
          create: (_) =>
            BlogPostListProvider(listBlogPostUseCase: listBlogPostUseCase),
        )
      ],
      child: BlogPostListPage(),
    );
  }

  static Widget provideBlogPostCreatePage() {
    return MultiProvider(
      providers: [
        ...provideCommonProviders(),
        ChangeNotifierProvider(
          create: (_) =>
            BlogPostCreateProvider(
              createBlogPostUseCase: createBlogPostUseCase,
              uploadBlogPostUseCase: uploadBlogPostUseCase,
            ),
        )
      ],
      child: BlogPostCreatePage(),
    );
  }

  static Widget provideBlogPostReadPage(int id) {
    return MultiProvider(
      providers: [
        ...provideCommonProviders(),
        ChangeNotifierProvider(
            create: (_) =>
            BlogPostReadProvider(
                readBlogPostUseCase: readBlogPostUseCase,
                deleteBlogPostUseCase: deleteBlogPostUseCase,
                blogPostId: id
            )..fetchBlogPost()
        ),
      ],
      child: BlogPostReadPage(),
    );
  }

  static Widget provideBlogPostModifyPage(
      int blogPostId, String title, String content) {
    return MultiProvider(
      providers: [
        ...provideCommonProviders(),
        ChangeNotifierProvider(
          create: (_) => BlogPostModifyProvider(
            updateBlogPostUseCase: updateBlogPostUseCase,
            blogPostId: blogPostId,
          ), // Load board data (if needed)
        ),
      ],
      child: BlogPostModifyPage(
        blogPostId: blogPostId, // Pass the boardId
        initialTitle: title, // Pass the initial title
        initialContent: content, // Pass the initial content
      ),
    );
  }
}
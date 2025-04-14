import 'package:flutter/cupertino.dart';

import '../../../../common_ui/pagination.dart';
import '../../providers/blog_post_list_provider.dart';
import 'blog_post_list.dart';

class BlogPostPageContent extends StatelessWidget {
  final BlogPostListProvider blogPostListProvider;
  final Function(int) onPageChanged;

  BlogPostPageContent({
    required this.blogPostListProvider,
    required this.onPageChanged
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> blogPostList = List.from(blogPostListProvider.blogPostList);
    while (blogPostList.length < 6) {
      blogPostList.add(null);
    }
    print("blogPostList: ${blogPostList}");

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlogPostList(blogPostList: blogPostList),
            ),
          ),
        ),

        if (blogPostListProvider.blogPostList.isNotEmpty)
          Pagination(
            currentPage: blogPostListProvider.currentPage,
            totalPages: blogPostListProvider.totalPages,
            onPageChanged: onPageChanged,
          )
      ],
    );
  }
}
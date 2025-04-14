import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../blog_post_module.dart';
import '../../../domain/entity/blog_post.dart';
import '../../providers/blog_post_list_provider.dart';
import 'blog_post_card_item.dart';

class BlogPostList extends StatelessWidget {
  final List<dynamic> blogPostList;

  BlogPostList({
    required this.blogPostList
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(blogPostList.length, (index) {
        final blogPost = blogPostList[index];
        if (blogPost == null) {
          return SizedBox(height: 20);
        }

        return BlogPostCardItem(
          title: blogPost.title,
          content: blogPost.content,
          nickname: blogPost.nickname,
          createDate: blogPost.createDate,
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlogPostModule.provideBlogPostReadPage(blogPost.id)
              ),
            );

            if (result != null) {
              final blogPostListProvider = Provider.of<BlogPostListProvider>(context, listen: false);

              if (result['deleted'] == true) {
                // 게시글 삭제 처리
                blogPostListProvider.listBlogPosts(
                  blogPostListProvider.currentPage, // 현재 페이지 유지
                  6, // 고정된 perPage 값
                );
                // boardListProvider.removeBoard();
              } else if (result['updatedBlogPost'] != null &&
                  result['updatedBlogPost'] is BlogPost) {
                // 게시글 수정 처리
                final updatedBlogPost = result['updatedBlogPost'] as BlogPost;
                // blogPostListProvider.updateBlogPost(updatedBlogPost);
              }
            }
          }
        );
      })
    );
  }
}
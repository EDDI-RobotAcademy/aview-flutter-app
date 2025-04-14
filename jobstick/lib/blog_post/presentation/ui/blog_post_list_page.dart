import 'package:jobstick/blog_post/blog_post_module.dart';
import 'package:jobstick/common_ui/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/error_message.dart';
import '../../../common_ui/loading_indicator.dart';
import '../providers/blog_post_list_provider.dart';
import 'component/blog_post_page_content.dart';

class BlogPostListPage extends StatefulWidget {
  @override
  _BlogPostListPageState createState() => _BlogPostListPageState();
}

class _BlogPostListPageState extends State<BlogPostListPage> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final blogPostListProvider =
      Provider.of<BlogPostListProvider>(context, listen: false);

      blogPostListProvider.listBlogPosts(1, 6);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    final blogPostListProvider =
    Provider.of<BlogPostListProvider>(context, listen: false);

    blogPostListProvider.listBlogPosts(page, 6);
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = kToolbarHeight;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double contentTopPadding = appBarHeight;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          body: Container(),
          title: '블로그 게시판',
        ),
      ),
      body: SafeArea(
          child: Stack(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: contentTopPadding),
                  child: Consumer<BlogPostListProvider>(
                      builder: (context, blogPostListProvider, child) {
                        if (blogPostListProvider.isLoading &&
                            blogPostListProvider.blogPostList.isEmpty) {
                          return LoadingIndicator();
                        }

                        if (blogPostListProvider.message.isNotEmpty) {
                          return ErrorMessage(message: blogPostListProvider.message);
                        }

                        return BlogPostPageContent(
                          blogPostListProvider: blogPostListProvider,
                          onPageChanged: onPageChanged,
                        );
                      })),
              Positioned(
                  top: statusBarHeight,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BlogPostModule.provideBlogPostCreatePage()))
                          .then((_) {
                        final blogPostListProvider =
                        Provider.of<BlogPostListProvider>(context,
                            listen: false);
                        blogPostListProvider.listBlogPosts(1, 6);
                      });
                    },
                    child: Icon(Icons.add),
                    tooltip: '블로그 게시물 생성',
                  )),
            ],
          )),
    );
  }
}

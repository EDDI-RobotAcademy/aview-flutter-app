import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

import '../../blog_post_module.dart';
import '../../domain/entity/blog_post.dart';
import '../providers/blog_post_read_provider.dart';


class BlogPostReadPage extends StatefulWidget {
  @override
  _BlogPostReadPageState createState() => _BlogPostReadPageState();
}

class _BlogPostReadPageState extends State<BlogPostReadPage> {
  @override
  void initState() {
    super.initState();
    // 게시글 데이터를 가져옵니다.
    final blogPostReadProvider = Provider.of<BlogPostReadProvider>(context, listen: false);

    if (blogPostReadProvider.blogPost == null) {
      blogPostReadProvider.fetchBlogPost();
    }
  }

  Future<bool> _onWillPop() async {
    // 뒤로가기 버튼 이벤트 처리
    final blogPostReadProvider =
    Provider.of<BlogPostReadProvider>(context, listen: false);
    final updatedBlogPost = blogPostReadProvider.blogPost;

    // 현재 수정된 게시글 데이터를 반환하며 뒤로가기
    Navigator.pop(context, updatedBlogPost);
    return Future.value(false); // 기본 뒤로가기 동작 방지
  }

  @override
  Widget build(BuildContext context) {
    final blogPostReadProvider = Provider.of<BlogPostReadProvider>(context);

    return WillPopScope(
      onWillPop: _onWillPop, // 뒤로가기 이벤트 처리
      child: Scaffold(
        appBar: AppBar(
          title: Text('게시글 상세보기'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                final selectedBlogPost = blogPostReadProvider.blogPost;
                if (selectedBlogPost != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogPostModule.provideBlogPostModifyPage(
                        selectedBlogPost.id,
                        selectedBlogPost.title,
                        selectedBlogPost.content,
                      ),
                    ),
                  ).then((updatedData) {
                    if (updatedData != null &&
                        updatedData is Map<String, dynamic>) {
                      final updatedTitle =
                          updatedData['title'] ?? selectedBlogPost.title;
                      final updatedContent =
                          updatedData['content'] ?? selectedBlogPost.content;

                      // 생성된 Board 객체
                      final updatedBlogPost = BlogPost(
                        id: selectedBlogPost.id,
                        title: updatedTitle,
                        content: updatedContent,
                        nickname: selectedBlogPost.nickname,
                        createDate: selectedBlogPost.createDate,
                      );

                      // 상세 페이지 갱신
                      blogPostReadProvider.updateBlogPost(updatedBlogPost);
                    }
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context, blogPostReadProvider),
            ),
          ],
        ),
        body: _buildBody(blogPostReadProvider),
      ),
    );
  }

  Widget _buildBody(BlogPostReadProvider blogPostReadProvider) {
    if (blogPostReadProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (blogPostReadProvider.error != null) {
      return Center(
        child: Text(
          '블로그 포스트를 불러오는 데 실패했습니다.\n${blogPostReadProvider.error}',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),
        ),
      );
    } else if (blogPostReadProvider.blogPost == null) {
      return Center(child: Text('블로그 포스트를 찾을 수 없습니다.'));
    }

    final blogPost = blogPostReadProvider.blogPost!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: double.infinity,  // 🔥 이거 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blogPost.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '작성자: ${blogPost.nickname.isEmpty ? "익명" : blogPost.nickname}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              '작성일: ${blogPost.createDate}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: _buildHtmlContent(blogPost.content),
              ),
            ),
          ],
        ),
      ),
    );
    }

  Widget _buildHtmlContent(String content) {
    final document = parse(content);
    final elements = document.body?.children ?? [];

    print("Content: $content");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: elements.map((element) {
        print('Processing element: ${element.localName}');
        print('Element text: ${element.text}');

        if (element.localName == 'p') {
          final children = element.children;
          List<Widget> widgets = [];

          for (var child in children) {
            if (child.localName == 'img') {
              String? src = child.attributes['src'];
              print('Image src inside <p>: $src');

              if (src == null || src.isEmpty) {
                print('Error: Image src is null or empty inside <p>');
                widgets.add(SizedBox());
              } else if (src.startsWith('data:image')) {
                try {
                  final base64Str = src.contains(',')
                      ? src.split(',').last
                      : src;

                  print('Base64 image string: $base64Str');

                  if (base64Str.isEmpty) {
                    print('Error: Base64 string is empty');
                    widgets.add(_imageErrorWidget());
                  } else {
                    Uint8List bytes = base64Decode(base64Str);
                    print('Base64 decoding successful, byte length: ${bytes.length}');
                    widgets.add(Image.memory(
                      bytes,
                      errorBuilder: (_, __, ___) => _imageErrorWidget(),
                    ));
                  }
                } catch (e) {
                  print('Error decoding base64: $e');
                  widgets.add(_imageErrorWidget()); // Error widget for base64 decoding failure
                }
              } else {
                widgets.add(Image.network(
                  src,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => _imageErrorWidget(),
                ));
              }
            } else {
              widgets.add(Text(child.text));
            }
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets,
            ),
          );
        } else {
          return SizedBox();
        }
      }).toList(),
    );
  }

  Widget _imageErrorWidget() {
    return Center(
      child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
    );
  }

  void _showDeleteDialog(
      BuildContext context, BlogPostReadProvider blogPostReadProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('블로그 포스트 삭제'),
        content: Text('정말 이 블로그 포스트를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              await blogPostReadProvider.deleteBlogPost();
              Navigator.of(context).pop();
              Navigator.of(context).pop({'deleted': true});
            },
            child: Text('삭제'),
          ),
        ],
      ),
    );
  }
}

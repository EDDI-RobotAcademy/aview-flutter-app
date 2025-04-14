import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;

import '../providers/blog_post_modify_provider.dart';

class BlogPostModifyPage extends StatefulWidget {
  final int blogPostId;
  final String initialTitle;
  final String initialContent;

  BlogPostModifyPage({
    required this.blogPostId,
    required this.initialTitle,
    required this.initialContent,
  });

  @override
  _BlogPostModifyPageState createState() => _BlogPostModifyPageState();
}

class _BlogPostModifyPageState extends State<BlogPostModifyPage> {
  late TextEditingController _titleController;
  late quill.QuillController _quillController;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);

    // HTML -> Quill Document 변환
    final delta = _convertHtmlToQuillDelta(widget.initialContent);
    _quillController = quill.QuillController(
      document: quill.Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  Delta _convertHtmlToQuillDelta(String htmlString) {
    final htmlDom.Document document = htmlParser.parse(htmlString);
    final delta = Delta();

    document.body?.nodes.forEach((node) {
      if (node is htmlDom.Element) {
        if (node.localName == "p") {
          delta.insert("${node.text}\n");
        } else if (node.localName == "strong") {
          delta.insert(node.text, {"bold": true});
        } else if (node.localName == "em") {
          delta.insert(node.text, {"italic": true});
        } else if (node.localName == "u") {
          delta.insert(node.text, {"underline": true});
        }
      }
    });

    return delta;
  }

  @override
  Widget build(BuildContext context) {
    final blogPostModifyProvider = Provider.of<BlogPostModifyProvider>(context);

    if (blogPostModifyProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('블로그 포스트 수정')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: quill.QuillEditor(
                controller: _quillController,
                focusNode: FocusNode(),
                scrollController: ScrollController(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitUpdate,
              child: Text('수정 완료'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitUpdate() {
    final updatedTitle = _titleController.text;
    final updatedContent = jsonEncode(_quillController.document.toDelta().toJson());

    print("Updated Title: $updatedTitle");
    print("Updated Content: $updatedContent");

    _getUserTokenAndUpdate(updatedTitle, updatedContent);
  }

  Future<void> _getUserTokenAndUpdate(String title, String content) async {
    try {
      final userToken = await _secureStorage.read(key: 'userToken');
      if (userToken == null) {
        throw Exception('User is not logged in.');
      }

      final blogPostModifyProvider =
      Provider.of<BlogPostModifyProvider>(context, listen: false);
      await blogPostModifyProvider.updateBlogPost(title, content, userToken);

      print("BlogPost updated successfully");
      Navigator.of(context).pop({'title': title, 'content': content});
    } catch (e) {
      print("Error during blogPost update: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('블로그 포스트 수정 실패: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    super.dispose();
  }
}

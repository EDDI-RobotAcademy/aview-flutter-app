import 'package:iosjobstick/board/board_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/board_create_provider.dart';

class BoardCreatePage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('게시물 등록')),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<BoardCreateProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: '제목'),
                    ),
                    TextField(
                      controller: contentController,
                      decoration: InputDecoration(labelText: '내용'),
                    ),
                    SizedBox(height: 20),

                    if (provider.isLoading) CircularProgressIndicator(),
                    if (provider.message.isNotEmpty)
                      Text(
                        provider.message,
                        style: TextStyle(color: Colors.red),
                      ),

                    ElevatedButton(
                      onPressed: () async {
                        final title = titleController.text.trim();
                        final content = contentController.text.trim();

                        if (title.isEmpty || content.isEmpty) {
                          provider.message = '제목 및 내용을 모두 입력하세요';
                          provider.notifyListeners();
                          return;
                        }

                        final board = await provider.createBoard(title, content);

                        if (board != null) {
                          print("게시물 등록 완료");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BoardModule.provideBoardReadPage(board.id),
                              )
                          );
                        }
                      },
                      child: Text('등록'),
                    )
                  ],
                );
              }
          )
      ),
    );
  }
}
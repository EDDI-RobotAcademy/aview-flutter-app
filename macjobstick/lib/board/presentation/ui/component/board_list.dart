import 'package:macjobstick/board/board_module.dart';
import 'package:macjobstick/board/presentation/providers/board_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entity/board.dart';
import 'card_item.dart';

class BoardList extends StatelessWidget {
  final List<dynamic> boardList;

  BoardList({
    required this.boardList
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(boardList.length, (index) {
          final board = boardList[index];
          if (board == null) {
            return SizedBox(height: 20);
          }

          return CardItem(
              title: board.title,
              content: board.content,
              nickname: board.nickname,
              createDate: board.createDate,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BoardModule.provideBoardReadPage(board.id)
                  ),
                );

                if (result != null) {
                  final boardListProvider = Provider.of<BoardListProvider>(context, listen: false);

                  if (result['deleted'] == true) {
                    // 게시글 삭제 처리
                    boardListProvider.listBoard(
                      boardListProvider.currentPage, // 현재 페이지 유지
                      6, // 고정된 perPage 값
                    );
                    // boardListProvider.removeBoard();
                  } else if (result['updatedBoard'] != null &&
                      result['updatedBoard'] is Board) {
                    // 게시글 수정 처리
                    final updatedBoard = result['updatedBoard'] as Board;
                    boardListProvider.updateBoard(updatedBoard);
                  }
                }
              }
          );
        })
    );
  }
}
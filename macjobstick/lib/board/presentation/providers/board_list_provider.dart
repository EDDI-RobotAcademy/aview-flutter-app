import 'package:flutter/cupertino.dart';

import '../../domain/entity/board.dart';
import '../../domain/usecases/list/list_board_use_case.dart';

class BoardListProvider with ChangeNotifier {
  final ListBoardUseCase listBoardUseCase;

  List<Board> boardList = [];
  String message = '';
  bool isLoading = false;

  int totalItems = 0;
  int totalPages = 0;
  int currentPage = 1;

  BoardListProvider({
    required this.listBoardUseCase
  });

  // Nuxt에서 Action에서 사용했던 Promise와 같은 역할임
  Future<void> listBoard(int page, int perPage) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final boardListResponse = await listBoardUseCase.call(page, perPage);

      if (boardListResponse.boardList.isEmpty) {
        message = '등록된 내용이 없습니다';
      } else {
        boardList = boardListResponse.boardList;
        totalItems = boardListResponse.totalItems;
        totalPages = boardListResponse.totalPages;
        currentPage = page;
      }
    } catch (e) {
      message = '게시글을 가져오는 중 문제가 발생했습니다';
    }

    isLoading = false;
    notifyListeners();
  }

  void changePage(int page, int perPage) {
    listBoard(page, perPage);
  }

  void updateBoard(Board updatedBoard) {
    final index = boardList.indexWhere((board) => board.id == updatedBoard.id);
    print('BoardListProvider updateBoard() boards: $boardList');
    if (index != -1) {
      print('BoardListProvider updateBoard() update list');
      boardList[index] = updatedBoard;
      notifyListeners();
    }
  }
}
import 'package:jobstick/board/domain/entity/board.dart';
import 'package:jobstick/board/domain/usecases/list/response/board_list_response.dart';

import '../data_sources/board_remote_data_source.dart';
import 'board_repository.dart';

class BoardRepositoryImpl implements BoardRepository {
  final BoardRemoteDataSource boardRemoteDataSource;

  BoardRepositoryImpl(this.boardRemoteDataSource);

  @override
  Future<BoardListResponse> listBoard(int page, int perPage) async {
    final boardListResponse =
    await boardRemoteDataSource.listBoard(page, perPage);

    return boardListResponse;
  }

  @override
  Future<Board> create(String title, String content, String userToken) async {
    try {
      final board = await boardRemoteDataSource.create(title, content, userToken);
      return board;
    } catch (e) {
      print("오류 발생: $e");
      throw Exception('게시물 생성 실패');
    }
  }

  @override
  Future<Board?> readBoard(int id) async {
    try {
      final board = await boardRemoteDataSource.fetchBoard(id);
      return board;
    } catch (e) {
      throw Exception("게시물 읽기 실패");
    }
  }

  @override
  Future<Board?> updateBoard(
      int boardId, String title, String content, String userToken) async {
    try {
      final updatedBoard = await boardRemoteDataSource.updateBoard(
          boardId, title, content, userToken);

      if (updatedBoard == null) {
        throw Exception("Invalid response or missing data field.");
      }

      return updatedBoard;
    } catch (e) {
      print('Error in updateBoard repository: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteBoard(int id, String userToken) async {
    try {
      return await boardRemoteDataSource.deleteBoard(id, userToken);
    } catch (e) {
      throw Exception('게시글 삭제 실패: $e');
    }
  }
}
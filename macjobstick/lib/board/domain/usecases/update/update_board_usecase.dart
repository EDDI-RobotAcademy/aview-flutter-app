import '../../entity/board.dart';

abstract class UpdateBoardUseCase {
  Future<Board?> execute(
      int boardId, String title, String content, String userToken);
}
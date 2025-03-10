import 'package:jobstick/board/domain/entity/board.dart';

abstract class ReadBoardUseCase {
  Future<Board?> execute(int boardId);
}
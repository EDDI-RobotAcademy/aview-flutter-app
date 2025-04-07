import 'package:iosjobstick/board/domain/entity/board.dart';

abstract class ReadBoardUseCase {
  Future<Board?> execute(int boardId);
}
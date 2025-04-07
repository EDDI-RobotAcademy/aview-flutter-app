import 'package:iosjobstick/board/domain/entity/board.dart';
import 'package:iosjobstick/board/domain/usecases/read/read_board_usecase.dart';
import 'package:iosjobstick/board/infrasturctures/repository/board_repository.dart';

class ReadBoardUseCaseImpl implements ReadBoardUseCase {
  final BoardRepository boardRepository;

  ReadBoardUseCaseImpl(
      this.boardRepository
      );

  @override
  Future<Board?> execute(int boardId) async {
    try {
      final board = await boardRepository.readBoard(boardId);
      return board;
    } catch (e) {
      return null;
    }
  }
}
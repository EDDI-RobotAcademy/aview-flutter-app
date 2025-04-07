import 'package:iosjobstick/board/domain/usecases/update/update_board_usecase.dart';

import '../../../infrasturctures/repository/board_repository.dart';
import '../../entity/board.dart';

class UpdateBoardUseCaseImpl implements UpdateBoardUseCase {
  final BoardRepository boardRepository;

  UpdateBoardUseCaseImpl(this.boardRepository);

  @override
  Future<Board?> execute(
      int boardId, String title, String content, String userToken) async {
    try {
      final updatedBoard =
      await boardRepository.updateBoard(boardId, title, content, userToken);

      // null 체크
      if (updatedBoard == null) {
        throw Exception('Updated board is null');
      }

      print(
          "UpdateBoardUseCaseImpl Updated Board from UseCase: ${updatedBoard.toJson()}");
      return updatedBoard;
    } catch (e) {
      print("Error in UpdateBoardUseCase: $e");
      rethrow; // 에러를 다시 던져서 상위에서 처리하도록 함
    }
  }
}
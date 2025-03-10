import 'package:jobstick/board/domain/entity/board.dart';
import 'package:jobstick/board/domain/usecases/list/response/board_list_response.dart';
import '../../../infrasturctures/repository/board_repository.dart';
import 'create_board_use_case.dart';

class CreateBoardUseCaseImpl implements CreateBoardUseCase {
  final BoardRepository boardRepository;

  CreateBoardUseCaseImpl(this.boardRepository);

  @override
  Future<Board> execute(String title, String content, String userToken) async {
    try {
      final board = await boardRepository.create(title, content, userToken);
      return board;
    } catch (e) {
      throw Exception('게시물 생성 실패');
    }
  }
}
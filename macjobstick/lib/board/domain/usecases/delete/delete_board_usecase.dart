abstract class DeleteBoardUseCase {
  Future<void> execute(int boardId, String userToken);
}
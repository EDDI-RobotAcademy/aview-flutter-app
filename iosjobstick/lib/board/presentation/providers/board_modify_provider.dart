import 'package:flutter/material.dart';
import '../../domain/entity/board.dart';
import '../../domain/usecases/update/update_board_usecase.dart';

class BoardModifyProvider extends ChangeNotifier {
  final UpdateBoardUseCase updateBoardUseCase;
  final int boardId;

  bool isLoading = false; // To track loading state
  String? errorMessage; // To store error message

  BoardModifyProvider({
    required this.updateBoardUseCase,
    required this.boardId,
  });

  Future<Board?> updateBoard(
      String title, String content, String userToken) async {
    try {
      isLoading = true;
      notifyListeners(); // Notify listeners to update UI (loading state)

      print('BoardModifyProvider Updating board with ID: $boardId');
      print(
          'BoardModifyProvider New Title: $title, New Content: $content, UserToken: $userToken');

      // Call the execute method on the use case to update the board
      final updatedBoard =
      await updateBoardUseCase.execute(boardId, title, content, userToken);

      print(
          'BoardModifyProvider Board updated successfully: ${updatedBoard?.toJson()}');

      // Reset error message and stop loading
      errorMessage = null;
      isLoading = false;
      notifyListeners();

      return updatedBoard; // Return the updated board
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to update board: $e';
      notifyListeners(); // Notify listeners to update UI (error state)
      print('Error during update: $errorMessage');

      // Re-throw the error if needed for higher-level handling
      throw Exception(errorMessage);
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entity/board.dart';
import '../../domain/usecases/create/create_board_use_case.dart';

class BoardCreateProvider with ChangeNotifier {
  final CreateBoardUseCase createBoardUseCase;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  BoardCreateProvider({
    required this.createBoardUseCase
  });

  bool isLoading = false;
  String message = '';

  Future<Board?> createBoard(String title, String content) async {
    isLoading = true;
    notifyListeners();

    try {
      final userToken = await secureStorage.read(key: 'userToken');

      if (userToken == null) {
        message = '로그인 상태가 아니므로 로그인을 먼저 해주세요.';
        isLoading = false;
        notifyListeners();
        return null;
      }

      final board = await createBoardUseCase.execute(title, content, userToken);

      return board;
    } catch (e) {
      message = '게시물 생성에 실패했습니다. 오류: $e';
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
import 'package:jobstick/simple_chat/domain/usecases/send_simple_chat_usecase_impl.dart';
import 'package:flutter/cupertino.dart';

class SimpleChatProvider extends ChangeNotifier {
  SendSimpleChatUseCaseImpl sendSimpleChatUseCase;

  SimpleChatProvider({
    required this.sendSimpleChatUseCase
  });

  void updateUseCase(SendSimpleChatUseCaseImpl newUseCase) {
    sendSimpleChatUseCase = newUseCase;
    notifyListeners();
  }

  Future<String> sendMessageToLLM(String message) async {
    final response = await sendSimpleChatUseCase.execute(message);
    notifyListeners();
    return response;
  }
}
import 'package:jobstick/simple_chat/domain/usecases/send_simple_chat_usecase.dart';
import '../../infrastructures/repository/simple_chat_repository.dart';

class SendSimpleChatUseCaseImpl implements SendSimpleChatUseCase {
  final SimpleChatRepository repository;

  SendSimpleChatUseCaseImpl(this.repository);

  @override
  Future<String> execute(String message) {
    print('Executing use case with message: $message');
    return repository.sendMessage(message);
  }
}

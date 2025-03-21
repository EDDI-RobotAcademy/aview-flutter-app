import '../../domain/entity/simple_chat_message.dart';

abstract class SimpleChatRepository {
  // Future<List<SimpleChatMessage>> fetchMessages();
  Future<String> sendMessage(String message);
}

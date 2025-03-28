import 'package:jobstick/simple_chat/infrastructures/repository/simple_chat_repository.dart';
import '../data_sources/simple_chat_remote_data_source.dart';

class SimpleChatRepositoryImpl implements SimpleChatRepository {
  final SimpleChatRemoteDataSource remoteDataSource;

  SimpleChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> sendMessage(String message) async {
    print('Repository sending message: $message');
    try {
      final generatedText = await remoteDataSource.fetchLLMGeneratedText(message);
      print('Generated response: $generatedText');
      return generatedText;
    } catch (e) {
      print('Error: $e');
      throw Exception("Failed to send message: $e");
    }
  }
}

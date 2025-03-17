abstract class RequestUserTokenUseCase {
  Future<String> execute(String accessToken, int userId, String email, String nickname);
}
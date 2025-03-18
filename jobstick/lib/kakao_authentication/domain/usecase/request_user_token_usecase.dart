abstract class RequestUserTokenUseCase {
  Future<String> execute(String accessToken, int userId, String email, String nickname, String gender, String ageRange, String birthyear);
}
abstract class UploadBlogPostUseCase {
  Future<String> execute(String title, String compressedHtmlContent, String userToken);
}

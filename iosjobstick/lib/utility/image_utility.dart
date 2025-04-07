import 'dart:convert';
import 'dart:io' as io;

String imageToBase64(String imagePath) {
  // 이미지 파일을 바이너리로 읽기
  final imageFile = io.File(imagePath);
  final bytes = imageFile.readAsBytesSync();

  // 바이너리 데이터를 Base64로 인코딩
  String base64Image = base64Encode(bytes);

  return base64Image;
}

String convertImageToHtml(String imageUrl) {
  print("convertImageToHtml()");
  // imageUrl이 로컬 경로일 경우, Base64로 변환
  if (imageUrl.startsWith('/data/user/')) {
    print("is startWith /data/user");
    String base64Image = imageToBase64(imageUrl);
    // Base64 형식으로 HTML img 태그에 넣기
    return '<img src="data:image/jpeg;base64,$base64Image" />';
  }
  // 네트워크 이미지일 경우 URL을 그대로 사용
  return '<img src="$imageUrl" />';
}
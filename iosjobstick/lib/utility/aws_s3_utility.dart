import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AwsS3Utility {
  static final String bucketName = dotenv.env['AWS_BUCKET_NAME'] ?? '';
  static final String region = dotenv.env['AWS_REGION'] ?? '';
  static final String accessKey = dotenv.env['AWS_ACCESS_KEY_ID'] ?? '';
  static final String secretKey = dotenv.env['AWS_SECRET_ACCESS_KEY'] ?? '';

  static Future<String?> downloadFile(String domain, String fileName) async {
    final String s3Url = 'https://$bucketName.s3.$region.amazonaws.com/$domain/$fileName';
    try {
      // S3에서 파일을 다운로드합니다
      final response = await http.get(Uri.parse(s3Url));

      if (response.statusCode == 200) {
        return response.body; // 다운로드한 HTML 파일의 내용을 반환
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
      throw Exception('Error downloading file: $e');
    }
  }
}
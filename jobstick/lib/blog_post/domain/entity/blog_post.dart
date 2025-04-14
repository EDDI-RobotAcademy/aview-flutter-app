class BlogPost {
  final int id;
  final String title;
  String content;
  final String nickname;
  final String createDate;

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.nickname,
    required this.createDate,
  });

  @override
  String toString() {
    return 'BlogPost{id: $id, title: $title, content: $content, nickname: $nickname, createDate: $createDate}';
  }

  Map<String, dynamic> toJson() {
    return {
      'blogPostId': id,
      'title': title,
      'content': content,
      'nickname': nickname,
      'createDate': createDate,
    };
  }

  // JSON 데이터를 Board 객체로 변환
  factory BlogPost.fromJson(Map<String, dynamic> json) {
    try {
      print('JSON 변환 시작: $json');

      return BlogPost(
        id: json['id'],
        title: json['title'] ?? 'No Title',
        content: json['content'] ?? '',
        nickname: json['nickname'] ?? '익명',
        createDate: json['createDate'] ?? 'Unknown',
      );
    } catch (e) {
      print('JSON 파싱 중 오류: $json, Error: $e');
      rethrow;
    }
  }
}
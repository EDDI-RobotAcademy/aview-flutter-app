class Board {
  final int id;
  final String title;
  final String content;
  final String nickname;
  final String createDate;

  Board({
    required this.id,
    required this.title,
    required this.content,
    required this.nickname,
    required this.createDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'boardId': id,
      'title': title,
      'content': content,
      'nickname': nickname,
      'createDate': createDate,
    };
  }

  // JSON 데이터를 Board 객체로 변환
  factory Board.fromJson(Map<String, dynamic> json) {
    try {
      print('JSON 변환 시작: $json');

      return Board(
        id: json['boardId'],
        title: json['title'] ?? 'No Title',
        content: json['content'] ?? '',
        nickname: json['nickname'] ?? '익명',
        createDate: json['createData'] ?? 'Unknown',
      );
    } catch (e) {
      print('JSON 파싱 중 오류: $json, Error: $e');
      rethrow;
    }
  }
}
// [수정됨] 불필요한 import 삭제함 (이제 경고 안 뜸)

// 1. 리스트 화면용 데이터 모델 (list.json)
class TestMeta {
  final String title;
  final String category;
  final String fileName;
  final String thumbnail;

  TestMeta({
    required this.title,
    required this.category,
    required this.fileName,
    required this.thumbnail,
  });

  factory TestMeta.fromJson(Map<String, dynamic> json) {
    return TestMeta(
      title: json['title'] ?? '제목 없음',
      category: json['category'] ?? '기타',
      fileName: json['file'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}

// 2. 상세 문제용 데이터 모델 (각 테스트 json)
class TestDetail {
  final String title;
  final String category;
  final String question;
  final List<String> selects;
  final List<String> answers;
  final List<String> emojis;

  TestDetail({
    required this.title,
    required this.category,
    required this.question,
    required this.selects,
    required this.answers,
    required this.emojis,
  });

  factory TestDetail.fromJson(Map<String, dynamic> json) {
    return TestDetail(
      title: json['title'] ?? '테스트',
      category: json['category'] ?? '심리',
      question: json['question'] ?? '질문이 없습니다.',
      selects: List<String>.from(json['selects'] ?? []),
      answers: List<String>.from(json['answer'] ?? []),
      emojis: json['emoji'] != null ? List<String>.from(json['emoji']) : [],
    );
  }
}
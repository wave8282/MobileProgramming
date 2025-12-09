import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// JSON 데이터를 읽어서 Firebase에 업로드하는 함수
Future<void> uploadJsonToFirebase() async {
  try {
    // 1. 전체 목록 파일(list.json) 읽기
    final String listResponse = await rootBundle.loadString('res/api/list.json');
    final Map<String, dynamic> listData = json.decode(listResponse);
    final List<dynamic> questions = listData['questions'];

    final firestore = FirebaseFirestore.instance;
    int successCount = 0;

    // 2. 각 항목별 상세 데이터 읽어서 합치기
    for (var item in questions) {
      String fileName = item['file']; // 예: 'mbti'

      // 상세 JSON 파일 읽기
      final String detailResponse = await rootBundle.loadString('res/api/$fileName.json');
      final Map<String, dynamic> detailData = json.decode(detailResponse);

      // 3. 리스트 정보와 상세 정보를 합쳐서 하나의 데이터로 만듦
      final Map<String, dynamic> fullData = {
        'title': item['title'],         // 리스트에 있던 제목
        'category': item['category'],   // 리스트에 있던 카테고리
        'thumbnail': item['thumbnail'], // 리스트에 있던 이미지 경로
        'file_id': fileName,            // 파일명(ID로 사용)
        ...detailData,                  // 상세 파일의 내용 (question, answers 등)
      };

      // 4. Firestore 'personality_tests' 컬렉션에 업로드
      // 문서 ID를 파일명(fileName)으로 지정하면 중복 업로드 방지됨
      await firestore.collection('personality_tests').doc(fileName).set(fullData);

      successCount++;
      print("[$successCount] $fileName 업로드 완료");
    }

    print("=== 총 $successCount 건 업로드 성공! ===");

  } catch (e) {
    print("업로드 중 에러 발생: $e");
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/test_model.dart';
import '../detail/detail_page.dart'; // 결과 페이지 연결

class QuestionPage extends StatefulWidget {
  final TestDetail testData; // 이전 페이지에서 넘겨받은 문제 데이터

  const QuestionPage({super.key, required this.testData});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  // 현재 몇 번째 문제를 풀고 있는지
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 진행률 계산 (현재는 1문제짜리 테스트가 많지만, 확장성을 위해 1/1 = 100% 로직 유지)
    double progress = (_currentIndex + 1) / 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.testData.title),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 진행바 (LinearProgressIndicator)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey[200],
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Question ${_currentIndex + 1}",
              style: GoogleFonts.notoSansKr(color: Colors.grey),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 30),

            // 2. 질문 텍스트
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                    )
                  ]
              ),
              child: Text(
                widget.testData.question,
                style: GoogleFonts.notoSansKr(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(), // 버튼을 아래로 밀어냄

            // 3. 선택지 버튼 목록
            ...List.generate(widget.testData.selects.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      _submitAnswer(index);
                    },
                    child: Text(
                      widget.testData.selects[index],
                      style: GoogleFonts.notoSansKr(fontSize: 16),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 답변 제출 처리 함수
  void _submitAnswer(int index) {
    // 간단한 로직: 선택한 인덱스에 해당하는 결과(answers[index])를 바로 보여줌.
    // 문항이 여러 개라면 _currentIndex를 증가시키는 로직이 여기 들어갑니다.

    // 결과 페이지로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          question: widget.testData.question,
          answer: widget.testData.answers[index], // 선택한 답변에 매칭되는 결과
        ),
      ),
    );
  }
}
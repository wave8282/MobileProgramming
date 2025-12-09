import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // json 로딩용
import 'package:google_fonts/google_fonts.dart';
import '../model/test_model.dart';
import '../sub/question_page.dart'; // 문제 풀이 페이지 연결
import 'data_uploader.dart'; // [중요] 업로더 기능 import

class MainListPage extends StatefulWidget {
  const MainListPage({super.key});

  @override
  State<MainListPage> createState() => _MainListPageState();
}

class _MainListPageState extends State<MainListPage> {
  // JSON 데이터를 로드하는 함수
  Future<List<TestMeta>> _loadTestList() async {
    final String response = await rootBundle.loadString('res/api/list.json');
    final data = json.decode(response);
    List<dynamic> list = data['questions'];
    return list.map((e) => TestMeta.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          '심리테스트 모음',
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,

        // [여기부터 추가됨] DB 업로드 버튼
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload, color: Colors.blueAccent),
            tooltip: "Firebase로 데이터 보내기",
            onPressed: () async {
              // 1. 업로드 실행
              await uploadJsonToFirebase();

              // 2. 완료 메시지 띄우기
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Firebase로 모든 데이터 업로드 완료!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
        // [여기까지 추가됨]
      ),
      body: FutureBuilder<List<TestMeta>>(
        future: _loadTestList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오지 못했습니다.\n${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('준비된 테스트가 없습니다.'));
          }

          final tests = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: tests.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final item = tests[index];
                return _buildTestCard(item);
              },
            ),
          );
        },
      ),
    );
  }

  // 카드 디자인 위젯
  Widget _buildTestCard(TestMeta item) {
    return GestureDetector(
      onTap: () async {
        try {
          final String response = await rootBundle.loadString('res/api/${item.fileName}.json');
          final data = json.decode(response);
          final detailData = TestDetail.fromJson(data);

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuestionPage(testData: detailData)),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('테스트 파일을 찾을 수 없습니다: ${item.fileName}')),
          );
          print("에러 상세: $e");
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  item.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.category,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 10,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: GoogleFonts.notoSansKr(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
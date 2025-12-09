import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // [추가 1] 광고 패키지
import 'firebase_options.dart';
import 'main/mainlist_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Firebase 초기화
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase 초기화 성공!");
  } catch (e) {
    debugPrint("Firebase 초기화 실패: $e");
  }

  // 2. [추가 2] 애드몹(광고) 초기화 (이게 있어야 광고가 로딩됨)
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '심리테스트',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MainListPage(),
    );
  }
}
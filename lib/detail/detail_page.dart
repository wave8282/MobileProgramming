import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final String question;
  final String answer;
  const DetailPage({super.key, required this.question, required this.answer});

  @override
  State<StatefulWidget> createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("결과"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(widget.question, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
                  const SizedBox(height: 30),
                  Text(widget.answer,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  icon: const Icon(Icons.home),
                  label: const Text('메인으로'),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    final text = Uri.encodeComponent(
                        "저는 '${widget.question}' 테스트에서 '${widget.answer}' 결과가 나왔어요! 여러분도 해보세요!");
                    final url = "kakaotalk://send?text=$text";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("카카오톡을 설치해주세요!")),
                      );
                    }
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("카카오톡 공유"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ResultEmailWidget extends StatelessWidget {
  final String resultMessageAiEmail; // Ganti tipe data sesuai kebutuhan

  const ResultEmailWidget({super.key, required this.resultMessageAiEmail});

  @override
  Widget build(BuildContext context) {
    return GeminiResponseTypeView(
      builder: (context, child, response, loading) {
        return Card(
          elevation: 0,
          color: Colors.blue.shade800,
          child: Padding(
            padding: const EdgeInsets.all(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextButton(onPressed: (){
                    Clipboard.setData(ClipboardData(text: resultMessageAiEmail));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Teks disalin ke clipboard.'),
                        ),
                      );
                  }, child: Text("SALIN",),),
                ),
                GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: resultMessageAiEmail));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Teks disalin ke clipboard.'),
                      ),
                    );
                  },
                  child: Markdown(
                    onTapLink: (text, href, title) {
                      // Handle tappable link jika diperlukan
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    data: resultMessageAiEmail,
                    styleSheet: MarkdownStyleSheet(
                      // Atur gaya teks Markdown sesuai kebutuhan Anda
                      // p: const TextStyle(
                      //   color: Colors.white,
                      // ),
                    ),
                    selectable: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

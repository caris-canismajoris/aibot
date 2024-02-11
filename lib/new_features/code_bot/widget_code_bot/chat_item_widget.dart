import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../../config.dart';

class ResultWidget extends StatelessWidget {
  final String resultMessageAiCodes; // Ganti tipe data sesuai kebutuhan

  const ResultWidget({super.key, required this.resultMessageAiCodes});

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
                  child: TextButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: resultMessageAiCodes));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Teks disalin ke clipboard.'),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:Colors.black.withOpacity(0.4,),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "SALIN",
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(
                        ClipboardData(text: resultMessageAiCodes));
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
                    data: resultMessageAiCodes,
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

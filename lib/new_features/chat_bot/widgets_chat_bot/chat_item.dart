import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lottie/lottie.dart';

import '../../../config.dart';

class ChatItemWidget extends StatelessWidget {
  final Content content;
  bool animationShown = false;

  ChatItemWidget({required this.content});

  @override
  Widget build(BuildContext context) {
    return GeminiResponseTypeView(builder: (context, child, response, loading) {
      return GetBuilder<ChatLayoutController>(
        builder: (chatCtrl) {
          return Card(
            elevation: 0,
            color: content.role == 'model'
                ? Colors.blue.shade800
                : Colors.grey.withOpacity(0.35),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      top: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //  (content.role == 'model') ?
                        //  ChatCommonWidget().userImage(chatCtrl.argImage,) ,
                        //  : Image.asset(eImageAssets.voiceImage),
                        // const SizedBox(
                        //   width: 12,
                        // ),
                        Container(
                          decoration: BoxDecoration(
                          color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              (content.role == 'user') ? 'Anda' : 'Bot',
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            final textToCopy =
                                content.parts?.lastOrNull?.text ?? '';
                            Clipboard.setData(ClipboardData(text: textToCopy));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Teks disalin ke clipboard.'),
                              ),
                            );
                          },
                          child: Text("SALIN"),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onLongPress: () {
                      final textToCopy = content.parts?.lastOrNull?.text ?? '';
                      Clipboard.setData(ClipboardData(text: textToCopy));
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
                      data: content.parts?.lastOrNull?.text ??
                          'Tidak dapat menghasilkan jawaban!',
                      styleSheet: MarkdownStyleSheet(
                        // Atur gaya teks Markdown sesuai kebutuhan Anda
                        p: TextStyle(
                          fontSize: 16,
                          color:
                              (content.role == 'model') ? Colors.white : null,
                        ),
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
    });
  }
}

// void _showCopyDialog(BuildContext context, String textToCopy) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Salin Seluruhnya'),
//         content: const Text('Apakah Anda ingin menyalin seluruh teks?'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Tutup dialog
//             },
//             child: const Text('Tidak'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Tutup dialog
//               _copyToClipboard(context, textToCopy);
//             },
//             child: const Text('Ya'),
//           ),
//         ],
//       );
//     },
//   );
// }

// void _copyToClipboard(BuildContext context, String textToCopy) {
//   Clipboard.setData(ClipboardData(text: textToCopy));
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(
//       content: Text('Teks disalin ke clipboard.'),
//     ),
//   );
// }

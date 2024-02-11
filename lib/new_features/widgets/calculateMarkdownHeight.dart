import 'package:flutter/material.dart';

double calculateMarkdownHeight(String text, double maxWidth) {
  final textStyle = TextStyle(fontSize: 16.0); // Sesuaikan dengan gaya teks Anda
  final textSpan = TextSpan(text: text, style: textStyle);
  
  final textPainter = TextPainter(
    text: textSpan,
    maxLines: null,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);

  return textPainter.size.height + 22;
}


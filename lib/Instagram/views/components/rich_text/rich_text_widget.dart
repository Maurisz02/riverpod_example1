import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import './base_text.dart';
import './link_text.dart';

class RichTextWidget extends StatelessWidget {
  final Iterable<BaseText>
      texts; //its like a list but more flexible like not String then object, dynamic
  final TextStyle? styleForAll;

//a plain constructor of flutter
  const RichTextWidget({
    super.key,
    this.styleForAll,
    required this.texts,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texts.map(
          (baseText) {
            if (baseText is LinkText) {
              return TextSpan(
                text: baseText.text,
                style: styleForAll?.merge(baseText.style),
                recognizer: TapGestureRecognizer()..onTap = baseText.onTapped,
              );
            } else {
              return TextSpan(
                text: baseText.text,
                style: styleForAll?.merge(baseText.style),
              );
            }
          },
        ).toList(),
      ),
    );
  }
}

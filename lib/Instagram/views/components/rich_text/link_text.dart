import 'package:flutter/foundation.dart' show immutable, VoidCallback;

import './base_text.dart';

@immutable
class LinkText extends BaseText {
  final VoidCallback onTapped;

//its super because extends basetext which ha text and style
//link text need to have a function
  const LinkText({
    required super.text,
    required this.onTapped,
    super.style,
  });
}

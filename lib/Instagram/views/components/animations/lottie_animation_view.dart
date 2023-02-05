import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import './models/lottie_animation.dart';

class LottieAnimationView extends StatelessWidget {
  final LottieAnimation animation;
  final bool repeat;
  final bool reverse;

  const LottieAnimationView({
    super.key,
    required this.animation,
    this.repeat =
        true, //set the default value like this if it can be null required this.repeat ?? false
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      animation.fullPath,
      reverse: reverse,
      repeat: repeat,
    );
  }
}

extension GetFullPath on LottieAnimation {
  String get fullPath => 'assets/animations/$name.json';
}

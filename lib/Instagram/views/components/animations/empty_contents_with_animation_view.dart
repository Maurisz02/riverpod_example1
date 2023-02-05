import 'package:flutter/material.dart';

import './empty_contents_animation_view.dart';

class EmptyContentsWithAnimationView extends StatelessWidget {
  final String text;
  const EmptyContentsWithAnimationView({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white54,
                  ),
            ),
          ),
          const EmptyContentAnimationView(),
        ],
      ),
    );
  }
}

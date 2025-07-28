import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewsItemLoading extends StatelessWidget {
  const NewsItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 150,
        child: Stack(
          children: [
            Bone(
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.circular(8),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Bone.text(words: 3, fontSize: 12),
                  SizedBox(height: 8),
                  Bone.text(words: 2, fontSize: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

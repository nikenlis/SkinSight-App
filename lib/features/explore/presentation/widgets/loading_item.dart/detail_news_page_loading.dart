import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/theme/app_color.dart';

class DetailNewsPageLoading extends StatelessWidget {
  const DetailNewsPageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Skeletonizer(
      enabled: true,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight / 2 + 40,
            child: Container(color: Colors.grey.shade300),
          ),

          // Gradient Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight / 2 + 40,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xCC000000),
                    Color(0x99000000),
                    Color(0x00000000),
                  ],
                ),
              ),
            ),
          ),

          // Content scrollable skeleton
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _DummyHeaderDelegate(topPadding: topPadding),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Author
                      Container(height: 24, width: 150, color: Colors.grey.shade300),
                      const SizedBox(height: 30),

                      // Content paragraphs
                      Column(
                        children: List.generate(20, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Container(
                              height: 14,
                              width: double.infinity,
                              color: Colors.grey.shade300,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// Dummy header delegate for skeleton state
class _DummyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double topPadding;

  _DummyHeaderDelegate({required this.topPadding});

  @override
  double get maxExtent => 300;
  @override
  double get minExtent => topPadding + 56;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(height: 24, width: 200, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(height: 12, width: 80, color: Colors.grey.shade300),
                const SizedBox(width: 12),
                const SizedBox(width: 12),
                Container(height: 12, width: 60, color: Colors.grey.shade300),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

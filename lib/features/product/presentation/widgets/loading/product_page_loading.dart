import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductPageLoading extends StatelessWidget {
  const ProductPageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Skeletonizer(
        enabled: true,
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              floating: true,
              backgroundColor: Colors.white,
              expandedHeight: 420,
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 16),

                    // Search bar & filter button
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.search),
                                SizedBox(width: 4),
                                Text("Search product"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          width: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const FaIcon(FontAwesomeIcons.sliders),
                        )
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Title row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Brands", style: TextStyle(fontSize: 18)),
                        Text("View all"),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Grid dummy brand
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 80,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (_, __) => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Dummy tabs
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(30),
                child: Row(
                  children: List.generate(4, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      // padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // color: Colors.grey.shade300,
                      ),
                      child: const Text("cgcshd"),
                    );
                  }),
                ),
              ),
            ),
          ],
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.667,
              ),
              itemBuilder: (_, __) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

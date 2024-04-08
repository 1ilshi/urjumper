import 'package:flutter/material.dart';

import 'brandpages/adidas.dart';
import 'brandpages/nike.dart';
import 'brandpages/puma.dart';
import 'brandpages/vans.dart';

class Brands extends StatelessWidget {
  Brands({super.key});

  // List of brand logos
  final List<String> brandLogos = [
    'lib/images/nike-logo.png',
    'lib/images/vans-logo.png',
    'lib/images/puma-logo.png',
    'lib/images/adidas-logo.png',
    // Add more brand logos as needed
  ];

  // Corresponding brand page routes
  final List<Widget> brandPages = [
    const NikePage(),
    const VansPage(),
    const PumaPage(),
    const AdidasPage(),
    // Ensure the order matches brandLogos list
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.0, // Aspect ratio of each grid item (square)
          ),
          itemCount: brandLogos.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to corresponding brand page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => brandPages[index],
                  ),
                );
              },
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  child: Image.asset(
                    brandLogos[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class NikePage extends StatelessWidget {
  const NikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Nike Products', style: GoogleFonts.manrope(color: Colors.white),),
      ),
      body: const ProductList(brand: 'nike'),
    );
  }
}

class ProductList extends StatelessWidget {
  final String brand;

  const ProductList({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('product')
          .doc('shoes')
          .collection(brand)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No products available'));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> product = doc.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(product['name']),
              subtitle: Text(product['price']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final String assetReference = product['poster'] ?? '';
    final String assetPath = assetReference;

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'], style: GoogleFonts.manrope(color: Colors.white),),
      ),
      body: Center(
        child: Column(

          children: [
            GestureDetector(
              onTap: () {
                if (assetPath.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
              child: assetPath.isNotEmpty
                  ? Image.asset(
                assetPath,
                width: 400,
                height: 400,
                fit: BoxFit.fitHeight,
              )
                  : const Placeholder(
                fallbackHeight: 400,
                fallbackWidth: 400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Price: ${product['price']}',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Color: ${product['color']}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Description: ${product['description']}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

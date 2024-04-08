import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';

class UserHotDeal extends StatefulWidget {
  const UserHotDeal({super.key});

  @override
  _UserHotDealState createState() => _UserHotDealState();
}

class _UserHotDealState extends State<UserHotDeal> {
  final _controller = PageController();
  late List<DocumentSnapshot> _pumaProducts;
  late List<DocumentSnapshot> _adidasProducts;
  late List<DocumentSnapshot> _vansProducts;

  @override
  void initState() {
    super.initState();
    _fetchRandomProducts();
  }

  Future<void> _fetchRandomProducts() async {
    final pumaQuery = FirebaseFirestore.instance
        .collection('product')
        .doc('shoes')
        .collection('puma')
        .limit(10); // Adjust limit as needed
    final adidasQuery = FirebaseFirestore.instance
        .collection('product')
        .doc('shoes')
        .collection('adidas')
        .limit(10); // Adjust limit as needed
    final vansQuery = FirebaseFirestore.instance
        .collection('product')
        .doc('shoes')
        .collection('vans')
        .limit(10); // Adjust limit as needed

    final pumaSnapshot = await pumaQuery.get();
    final adidasSnapshot = await adidasQuery.get();
    final vansSnapshot = await vansQuery.get();

    _pumaProducts = pumaSnapshot.docs;
    _adidasProducts = adidasSnapshot.docs;
    _vansProducts = vansSnapshot.docs;

    _pumaProducts.shuffle();
    _adidasProducts.shuffle();
    _vansProducts.shuffle();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.vertical,
        children: [
          _buildProductImage(_pumaProducts.isNotEmpty ? _pumaProducts.first : null),
          _buildProductImage(_adidasProducts.isNotEmpty ? _adidasProducts.first : null),
          _buildProductImage(_vansProducts.isNotEmpty ? _vansProducts.first : null),
        ],
      ),
    );
  }

  Widget _buildProductImage(DocumentSnapshot? productSnapshot) {
    if (productSnapshot == null) {
      return Container(); // Placeholder widget if product is null
    }

    final productData = productSnapshot.data() as Map<String, dynamic>;
    final imageRef = productData['poster'] ?? '';

    return GestureDetector(
      onTap: () {
        if (productData.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: productData),
            ),
          );
        }
      },
      child: imageRef.isNotEmpty
          ? Image.asset(
        imageRef,
        fit: BoxFit.cover,
      )
          : Container(), // Placeholder widget if imageRef is empty
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? 'Product Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text('${product['name']}', style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700, fontSize: 28),
                ),
              ),
            ),

            const SizedBox(height: 10),
            Text('Price: ${product['price']}', style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20
            ),),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text('Color: ${product['color']}'),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text('Description: ${product['description']}'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'nike.dart';

class AdidasPage extends StatelessWidget {
  const AdidasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Adidas Products', style: GoogleFonts.manrope(color: Colors.white),),
      ),
      body: const ProductList(brand: 'adidas'),
    );
  }
}

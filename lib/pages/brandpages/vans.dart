import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'nike.dart';

class VansPage extends StatelessWidget {
  const VansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Vans Products', style: GoogleFonts.manrope(color: Colors.white),),
      ),
      body: const ProductList(brand: 'vans'),
    );
  }
}

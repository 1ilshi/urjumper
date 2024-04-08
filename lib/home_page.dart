import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:urjumper/pages/hot_deal.dart';
import 'package:urjumper/pages/post.dart';
import 'package:urjumper/pages/brands.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {

  final user = FirebaseAuth.instance.currentUser!;

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    //bottom-bar
    const UserHotDeal(),
    Brands(),
    const UserPost(),
  ];

  void _navigation(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  String? _username;

  @override
  void initState() {
    super.initState();
    // Call the function to get the username for the current user
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    try {
      // Call the function to get the username for the current user
      String? username = await getUsernameForCurrentUser();
      setState(() {
        _username = username;
      });
    } catch (e) {
      print('Error loading username: $e');
      setState(() {
        _username = null;
      });
    }
  }

  Future<String?> getUsernameForCurrentUser() async {
    // Get the current user's email
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

    // Query Firestore for the username based on the current user's email
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: currentUserEmail)
        .limit(1) // Limit to 1 document (since email should be unique)
        .get();

    // Retrieve the username from the first document (if found)
    if (querySnapshot.size > 0) {
      return querySnapshot.docs.first.get('username') as String?;
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          'URJUMPER',
          style: GoogleFonts.manrope(
              fontSize: 20,
            fontWeight:FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 80,),
            Image.asset('lib/images/urjumper-logo.png'),

            const SizedBox(height: 10,),
            Center(
              child: Text(
                  'Signed In as',
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 7,),
            Center(
              child: Text(
                '$_username',
                style: GoogleFonts.manrope(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const SizedBox(height: 20,),
            Center(
              child: Text(
                'Email : ${user.email!}'
              ),
            ),

            const SizedBox(height: 395,),
            Container(
              height: 37,
              width: 90,
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: MaterialButton(
                  onPressed: (){
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text('Sign Out', style: TextStyle(color: Colors.red),)
              ),
            )


          ],
        ),

      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.greenAccent,
            tabBackgroundColor: const Color(0xFF424242),
            onTabChange: (index) {
              _navigation(index);
              print(index);
            },
            gap: 8,
            padding: const EdgeInsets.all(18),
            tabs: const [
              GButton(
                icon: Icons.flash_on_sharp,
                text: 'Hot Deal',
              ),
              GButton(
                icon: Icons.shopping_bag,
                text: 'Brands',
              ),
              GButton(
                icon: Icons.post_add,
                text: 'Post'
              ),
            ],
          ),
        ),
      ),
    );
  }
}


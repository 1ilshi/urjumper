import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();

}

class _RegisterPageState extends State<RegisterPage>{

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  Future signUp() async {
    if(passwordConfirm()){
      try {
        //create user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim()
        );
        //add user details
        await addUserDetails(
            _emailController.text.trim(), _usernameController.text.trim()
        );
      } on FirebaseAuthException catch(e){
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
          ),
        );
      }
    }
  }



  Future<void> addUserDetails(String email, String username) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'email': email,
        'username': username,
      });
    } catch (e) {
      print('Firestore Error: $e');
      // Handle the error (e.g., show error message to user)
    }
  }


  bool passwordConfirm(){
    if(_passwordController.text.trim() == _confirmPasswordController.text.trim()){
      return true;
    }else {
      return false;
    }
  }


  // initially show the login page
  bool showLoginPage = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column (
                children: [
                  Image.asset('lib/images/urjumper-logo.png'),
                  const SizedBox(height: 5,),
                  Text(
                    'Register here',
                    style: GoogleFonts.manrope(
                        fontSize: 40,
                        fontWeight: FontWeight.w700
                    ),
                    ),
                  const SizedBox(height: 20,),
                  //email text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email Address',
                          ),
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 13,),
                  //username text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Username',
                          ),
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 13,),
                  //password text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                          ),
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 13,),
                  //password-confirm text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Confirm Password',
                          ),
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 13,),
                  //sign-up button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                            child: Text('Sign Up',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            )),
                      ),
                    ),
                  ),


                  const SizedBox(height: 13,),
                  //Not a member? Register now(button)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('I am a member!',
                        style: TextStyle(
                            color: Colors.black87
                        ),),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: const Text(
                          ' Login now',
                          style: TextStyle(color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )




    );
  }

}
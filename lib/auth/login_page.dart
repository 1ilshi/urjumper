import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState() ;

}

class _LoginPageState extends State<LoginPage>{

  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


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
              'URJUMPER',
              style: GoogleFonts.manrope(
                  fontSize: 40,
                  fontWeight: FontWeight.w800
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
                const SizedBox(height: 8,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const ForgotPasswordPage();
                }));
                },
                        child: const Text(
                            'Forgot Password?',
                          style: TextStyle(color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8,),
                //sign-in button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                          child: Text('Sign In',
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
                    const Text('Not a member?',
                    style: TextStyle(
                      color: Colors.black87
                    ),),
                    GestureDetector(
                      onTap: widget.showRegisterPage,
                      child: const Text(
                        ' Register now',
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



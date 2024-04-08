import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async{
    var email = _emailController.text.trim();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link has been sent to your email'),
        ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('lib/images/urjumper-logo.png'),

          const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            'Enter Your Email and we will send you a password reset link',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 10,),


        //email text field
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
        const SizedBox(height: 17,),


        Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20)
          ),
          child: MaterialButton(
          onPressed: passwordReset,
          child: const Text('Reset Password'),
          ),
        )
        ],
      ),
    );
  }
}


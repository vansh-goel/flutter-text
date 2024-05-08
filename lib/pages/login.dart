import 'package:flutter/material.dart';
import 'package:myapp/components/my_button.dart';
import 'package:myapp/components/my_text_field.dart';
import 'package:myapp/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),),),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
            child: Center (
              child: Padding(padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50,),
                  // Logo
                  Icon(
                    Icons.message,
                    size: 80,
                    color: Colors.indigo.shade500
                  ),
                  const SizedBox(height: 50),
                  // Welcome Back
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Email
                    MyTextField(
                      controller: emailController, 
                      hintText: "Email", 
                      obscureText: false
                    ),
                    const SizedBox(height: 10),
                  // Password
                    MyTextField(
                      controller: passwordController, 
                      hintText: "Password", 
                      obscureText: true
                    ),
                    const SizedBox(height: 10),

                  // Sign in
                    MyButton(onTap: signIn, text: "Sign In"),
                  // Not a Member? Register
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a Member?", style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Register Now",
                          style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      )
                    ],
                  )
                ],
              ),
              ) 
            )
      ) 
    );
  }
}
import 'package:flutter/material.dart';
import 'package:myapp/components/my_button.dart';
import 'package:myapp/components/my_text_field.dart';
import 'package:myapp/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signup() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match!"),
        ),
      );
      return;
    }

    final authservice = Provider.of<AuthService> (context, listen: false);
    try {
      await authservice.signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
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
                    "Let's Get You Started!",
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

                  // Confirm Password

                    MyTextField(
                      controller: confirmPasswordController, 
                      hintText: "Confirm Password", 
                      obscureText: true
                    ),
                    const SizedBox(height: 10),

                  // Sign in

                    MyButton(onTap: signup, text: "Sign Up"),
                  
                  // Not a Member? Register
                  
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a Member?", style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text("Login Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
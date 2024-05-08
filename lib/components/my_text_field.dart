import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
           borderRadius: const BorderRadius.all(
                Radius.circular(10.0), 
          ),
          borderSide: BorderSide(color: Colors.grey.shade200.withOpacity(0.1)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: Colors.grey.shade400.withOpacity(0.2),
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white)
      ),
    );
  }
}
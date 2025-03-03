import 'package:flutter/material.dart';
class MyTextField extends StatelessWidget {
  final String hinttext;
  final bool obsecureText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  const MyTextField({super.key,required this.hinttext,
    required this.obsecureText,required this.controller,
    required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        obscureText: obsecureText,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: hinttext,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),

        ),
      ),
    );
  }
}

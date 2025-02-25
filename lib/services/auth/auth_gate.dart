
import 'package:f_bmi_tracker/pages/user_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'login_or_register.dart';
class AuthGate extends StatelessWidget {
   AuthGate({super.key});

  final authService= AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasData){
            return  UserDetailsScreen(user: authService.getCurrentUser()!);
          }else{
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}

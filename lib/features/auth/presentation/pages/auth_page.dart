import 'package:coocoo/features/auth/presentation/pages/signin.dart';
import 'package:coocoo/features/auth/presentation/pages/signup.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

   bool showLoginPage =true;
    
  void togglePage(){
    setState(() {
      showLoginPage =!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return SigninPage(onToggle: togglePage,);
    }
    else{
      return SignupPage(onToggle: togglePage);
    }
  }
}
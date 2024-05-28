import 'package:basketco/Pages/login_page.dart';
import 'package:basketco/Pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterPage  extends StatefulWidget {
  const LoginOrRegisterPage ({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPage() ;
}

class _LoginOrRegisterPage  extends State<LoginOrRegisterPage > {
  //initially show login page
  bool showLoginPage = true;

//toggle between login and register
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(onTap: togglePages);
    }else{
      return RegisterPage(onTap: togglePages);
    }
  }
}

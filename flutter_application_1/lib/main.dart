import 'package:flutter/material.dart';
import 'sign_in.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Docuease Login',
      debugShowCheckedModeBanner: false,
      home: SignInPage(), 
    );
  }
}

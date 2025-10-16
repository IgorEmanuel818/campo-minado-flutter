import 'package:flutter/material.dart';
import 'views/tela_login_view.dart';

void main() {
  runApp(const CampoMinadoApp());
}

class CampoMinadoApp extends StatelessWidget {
  const CampoMinadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campo Minado',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TelaLoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

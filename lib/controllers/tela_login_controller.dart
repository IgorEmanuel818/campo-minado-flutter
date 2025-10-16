import 'package:flutter/material.dart';

class TelaLoginController {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool camposPreenchidos() {
    return emailController.text.isNotEmpty && senhaController.text.isNotEmpty;
  }

  void limparCampos() {
    emailController.clear();
    senhaController.clear();
  }
}
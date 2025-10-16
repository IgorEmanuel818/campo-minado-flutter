import 'package:flutter/material.dart';

class TelaEsqueciSenhaController {
  final emailController = TextEditingController();
  final novaSenhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool camposValidos() {
    return emailController.text.isNotEmpty &&
        novaSenhaController.text.isNotEmpty &&
        confirmarSenhaController.text.isNotEmpty &&
        novaSenhaController.text == confirmarSenhaController.text;
  }

  void limparCampos() {
    emailController.clear();
    novaSenhaController.clear();
    confirmarSenhaController.clear();
  }
}
import 'package:flutter/material.dart';

class TelaCadastrarController {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool camposValidos() {
    return nomeController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        telefoneController.text.isNotEmpty &&
        senhaController.text.isNotEmpty &&
        confirmarSenhaController.text == senhaController.text;
  }

  void limparCampos() {
    nomeController.clear();
    emailController.clear();
    telefoneController.clear();
    senhaController.clear();
    confirmarSenhaController.clear();
  }
}
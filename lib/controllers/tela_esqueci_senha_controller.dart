import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaEsqueciSenhaController {
  final emailController = TextEditingController();
  final novaSenhaController = TextEditingController(); // opcional: pode remover
  final confirmarSenhaController = TextEditingController(); // opcional: pode remover

  bool emailValido() {
    return emailController.text.isNotEmpty;
  }

  Future<String?> enviarEmailResetSenha() async {
    if (!emailValido()) return "Informe seu e-mail";
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Erro inesperado: $e";
    }
  }

  void limparCampos() {
    emailController.clear();
    novaSenhaController.clear();
    confirmarSenhaController.clear();
  }
}
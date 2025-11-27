import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TelaRecuperarSenhaController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> enviarEmailRecuperacao(
    BuildContext context,
    String email,
  ) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Um link de redefinição de senha foi enviado para seu e-mail.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String mensagem = 'Erro ao enviar e-mail de recuperação';
      if (e.code == 'user-not-found') {
        mensagem = 'Não existe conta com este e-mail';
      } else if (e.code == 'invalid-email') {
        mensagem = 'E-mail inválido';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro inesperado ao enviar recuperação')),
      );
    }
  }
}
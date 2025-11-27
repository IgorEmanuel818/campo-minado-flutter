import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../views/tela_escolhas_view.dart';

class TelaLoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUsuario(
    BuildContext context,
    String email,
    String senha,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TelaEscolhasView()),
      );
    } on FirebaseAuthException catch (e) {
      String mensagem = 'Erro ao fazer login';
      if (e.code == 'user-not-found') {
        mensagem = 'Usuário não encontrado';
      } else if (e.code == 'wrong-password') {
        mensagem = 'Senha incorreta';
      } else if (e.code == 'invalid-email') {
        mensagem = 'Email inválido';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro inesperado ao fazer login')),
      );
    }
  }
}
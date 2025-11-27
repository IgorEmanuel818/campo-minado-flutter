import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../views/tela_escolhas_view.dart';

class TelaCadastrarController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> cadastrarUsuario(
    BuildContext context, {
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    // Validação extra no controller
    if (senha.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(senha) ||
        !RegExp(r'[a-z]').hasMatch(senha) ||
        !RegExp(r'[0-9]').hasMatch(senha) ||
        !RegExp(r'[!@#\$&*~]').hasMatch(senha)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha não atende aos critérios de segurança')),
      );
      return;
    }

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      final uid = cred.user?.uid;
      if (uid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao obter usuário criado')),
        );
        return;
      }

      await _firestore.collection('usuarios').doc(uid).set({
        'nome': nome.trim(),
        'email': email.trim(),
        'telefone': telefone.trim(),
        'criadoEm': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TelaEscolhasView()),
      );
    } on FirebaseAuthException catch (e) {
      String mensagem = 'Erro ao cadastrar usuário';
      if (e.code == 'email-already-in-use') {
        mensagem = 'Este email já está em uso';
      } else if (e.code == 'weak-password') {
        mensagem = 'A senha é muito fraca';
      } else if (e.code == 'invalid-email') {
        mensagem = 'Email inválido';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro inesperado ao cadastrar')),
      );
    }
  }
}
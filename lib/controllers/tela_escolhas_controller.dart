import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../views/tela_campo_minado_view.dart';
import '../views/tela_dicas_view.dart';
import '../views/tela_sobre_view.dart';
import '../views/tela_configuracoes_view.dart';
import '../views/tela_login_view.dart';

class TelaEscolhasController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Busca os dados do usuário logado no Firestore
  Future<Map<String, dynamic>?> carregarDadosUsuario() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('usuarios').doc(user.uid).get();
    return doc.data();
  }

  /// Faz logout e volta para tela de login
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TelaLoginView()),
    );
  }

  /// Navega para o jogo
  void irParaJogo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaCampoMinadoView()),
    );
  }

  /// Navega para dicas
  void irParaDicas(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaDicasView()),
    );
  }

  /// Navega para sobre nós
  void irParaSobreNos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaSobreView()),
    );
  }

  /// Navega para configurações
  void irParaConfiguracoes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaConfiguracoesView()),
    );
  }
}
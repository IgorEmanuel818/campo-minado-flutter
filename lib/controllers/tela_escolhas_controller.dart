import 'package:flutter/material.dart';
import 'package:app_campo/views/tela_campo_minado_view.dart';
import 'package:app_campo/views/tela_dicas_view.dart';
import 'package:app_campo/views/tela_sobre_view.dart';
import 'package:app_campo/views/tela_configuracoes_view.dart';

class TelaEscolhasController {
  void irParaJogo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaCampoMinadoView()),
    );
  }

  void irParaDicas(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaDicasView()),
    );
  }

  void irParaSobreNos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaSobreView()),
    );
  }

  void irParaConfiguracoes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaConfiguracoesView()),
    );
  }
}
import 'package:flutter/material.dart';
import '../controllers/tela_configuracoes_controller.dart';

class TelaConfiguracoesView extends StatelessWidget {
  const TelaConfiguracoesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TelaConfiguracoesController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Essa funcionalidade ainda não está pronta')),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Center(
        child: Text(controller.mensagem, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
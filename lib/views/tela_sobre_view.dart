import 'package:flutter/material.dart';
import '../controllers/tela_sobre_controller.dart';

class TelaSobreView extends StatelessWidget {
  const TelaSobreView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TelaSobreController();

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre nós')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(controller.textoSobre),
        ),
      ),
    );
  }
}
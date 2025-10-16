import 'package:flutter/material.dart';
import '../controllers/tela_dicas_controller.dart';

class TelaDicasView extends StatelessWidget {
  const TelaDicasView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TelaDicasController();

    return Scaffold(
      appBar: AppBar(title: const Text('Como jogar')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.dicas.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(controller.dicas[index]),
            ),
          );
        },
      ),
    );
  }
}
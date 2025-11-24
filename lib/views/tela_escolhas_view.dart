import 'package:flutter/material.dart';
import '../controllers/tela_escolhas_controller.dart';

class TelaEscolhasView extends StatelessWidget {
  const TelaEscolhasView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TelaEscolhasController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icone_jogo.png', height: 120),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => controller.irParaJogo(context),
                child: const Text('Jogar'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.irParaDicas(context),
                child: const Text('Como jogar'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.irParaSobreNos(context),
                child: const Text('Sobre nós'),
              ),
              const SizedBox(height: 32),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => controller.irParaConfiguracoes(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
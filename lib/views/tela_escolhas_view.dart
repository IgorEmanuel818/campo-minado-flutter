import 'package:flutter/material.dart';
import 'tela_dicas_view.dart';
import 'tela_sobre_view.dart';
import 'tela_configuracoes_view.dart';

class TelaEscolhasView extends StatelessWidget {
  const TelaEscolhasView({super.key});

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Jogo ainda não implementado')),
                  );
                },
                child: const Text('Jogar'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TelaDicasView()));
                },
                child: const Text('Como jogar'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TelaSobreView()));
                },
                child: const Text('Sobre nós'),
              ),
              const SizedBox(height: 32),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TelaConfiguracoesView()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
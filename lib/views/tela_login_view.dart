import 'package:flutter/material.dart';
import '../controllers/tela_login_controller.dart';
import 'tela_esqueci_senha_view.dart';
import 'tela_cadastrar_view.dart';
import 'tela_escolhas_view.dart';
import 'tela_configuracoes_view.dart';

class TelaLoginView extends StatefulWidget {
  const TelaLoginView({super.key});

  @override
  State<TelaLoginView> createState() => _TelaLoginViewState();
}

class _TelaLoginViewState extends State<TelaLoginView> {
  final controller = TelaLoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icone_jogo.png', height: 100),
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: controller.senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (controller.camposPreenchidos()) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TelaEscolhasView()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos')),
                  );
                }
              },
              child: const Text('Entrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const TelaEsqueciSenhaView()));
              },
              child: const Text('Esqueci a senha'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const TelaCadastrarView()));
              },
              child: const Text('Cadastrar'),
            ),
            const Spacer(),
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
    );
  }
}
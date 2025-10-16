import 'package:flutter/material.dart';
import '../controllers/tela_cadastrar_controller.dart';
import 'tela_escolhas_view.dart';

class TelaCadastrarView extends StatefulWidget {
  const TelaCadastrarView({super.key});

  @override
  State<TelaCadastrarView> createState() => _TelaCadastrarViewState();
}

class _TelaCadastrarViewState extends State<TelaCadastrarView> {
  final controller = TelaCadastrarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              controller: controller.nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: controller.telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: controller.senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            TextField(
              controller: controller.confirmarSenhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmar Senha'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
              onPressed: () {
                if (controller.camposValidos()) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const TelaEscolhasView()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos corretamente')),
                  );
                }
              },
              child: const Text('Criar conta'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
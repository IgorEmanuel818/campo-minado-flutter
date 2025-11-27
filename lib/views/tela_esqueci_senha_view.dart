import 'package:flutter/material.dart';
import '../controllers/tela_esqueci_senha_controller.dart';
import 'tela_login_view.dart';

class TelaEsqueciSenhaView extends StatefulWidget {
  const TelaEsqueciSenhaView({super.key});

  @override
  State<TelaEsqueciSenhaView> createState() => _TelaEsqueciSenhaViewState();
}

class _TelaEsqueciSenhaViewState extends State<TelaEsqueciSenhaView> {
  final controller = TelaEsqueciSenhaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
              onPressed: () async {
                final erro = await controller.enviarEmailResetSenha();
                if (erro == null) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Sucesso'),
                      content: const Text('Enviamos um e-mail para redefinir sua senha.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const TelaLoginView()),
                            );
                          },
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Erro'),
                      content: Text(erro),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../controllers/tela_recuperar_senha_controller.dart';

class TelaRecuperarSenhaView extends StatefulWidget {
  const TelaRecuperarSenhaView({super.key});

  @override
  State<TelaRecuperarSenhaView> createState() => _TelaRecuperarSenhaViewState();
}

class _TelaRecuperarSenhaViewState extends State<TelaRecuperarSenhaView> {
  final _emailCtrl = TextEditingController();
  final _controller = TelaRecuperarSenhaController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRecuperar() async {
    if (_loading) return;
    if (_emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe seu e-mail')),
      );
      return;
    }

    setState(() => _loading = true);
    await _controller.enviarEmailRecuperacao(context, _emailCtrl.text);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar Senha")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              children: [
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _onRecuperar,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Enviar link de recuperação"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../controllers/tela_escolhas_controller.dart';

class TelaEscolhasView extends StatelessWidget {
  const TelaEscolhasView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TelaEscolhasController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela de Escolhas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: "Sair",
            onPressed: () => controller.logout(context),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: controller.carregarDadosUsuario(),
        builder: (context, snapshot) {
          final dados = snapshot.data;

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const CircularProgressIndicator(),

                  const SizedBox(height: 16),

                  if (dados != null)
                    Column(
                      children: [
                        Text(
                          "Bem-vindo, ${dados['nome'] ?? ''}!",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text("Email: ${dados['email'] ?? ''}", textAlign: TextAlign.center),
                        Text("Telefone: ${dados['telefone'] ?? ''}", textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                      ],
                    )
                  else
                    const Text("Bem-vindo!", textAlign: TextAlign.center),

                  Image.asset(
                    'assets/icone_jogo.png',
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text("Imagem não encontrada");
                    },
                  ),
                  const SizedBox(height: 30),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 48),
                          alignment: Alignment.center,
                        ),
                        onPressed: () => controller.irParaJogo(context),
                        child: const Text("Jogar"),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 48),
                          alignment: Alignment.center,
                        ),
                        onPressed: () => controller.irParaDicas(context),
                        child: const Text("Dicas de jogo"),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 48),
                          alignment: Alignment.center,
                        ),
                        onPressed: () => controller.irParaSobreNos(context),
                        child: const Text("Sobre nós"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.irParaConfiguracoes(context),
        child: const Icon(Icons.settings),
      ),
    );
  }
}
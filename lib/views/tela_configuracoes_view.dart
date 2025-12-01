import 'package:flutter/material.dart';
import '../controllers/tela_configuracoes_controller.dart';
import '../services/news_service.dart';

class TelaConfiguracoesView extends StatefulWidget {
  const TelaConfiguracoesView({super.key});

  @override
  State<TelaConfiguracoesView> createState() => _TelaConfiguracoesViewState();
}

class _TelaConfiguracoesViewState extends State<TelaConfiguracoesView> {
  final controller = TelaConfiguracoesController();
  final newsService = NewsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Column(
        children: [
          // Toggle temporizador
          SwitchListTile(
            title: const Text("Habilitar temporizador"),
            value: controller.habilitarTemporizador,
            onChanged: (value) {
              setState(() {
                controller.toggleTemporizador(value);
              });
            },
          ),

          const Divider(),

          // Notícias
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: newsService.getTopHeadlines(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Erro: ${snapshot.error}"));
                }
                final noticias = snapshot.data ?? [];
                if (noticias.isEmpty) {
                  return const Center(child: Text("Nenhuma notícia encontrada"));
                }

                return ListView.builder(
                  itemCount: noticias.length,
                  itemBuilder: (context, index) {
                    final noticia = noticias[index];
                    return ListTile(
                      title: Text(noticia["title"] ?? "Sem título"),
                      subtitle: Text(noticia["description"] ?? ""),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
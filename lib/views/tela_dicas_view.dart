import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaDicasView extends StatefulWidget {
  const TelaDicasView({super.key});

  @override
  State<TelaDicasView> createState() => _TelaDicasViewState();
}

class _TelaDicasViewState extends State<TelaDicasView> with TickerProviderStateMixin {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final _searchCtrl = TextEditingController();
  final _notaCtrl = TextEditingController();

  String _termo = '';
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _notaCtrl.dispose();
    _tab.dispose();
    super.dispose();
  }

  Future<void> _salvarAnotacao() async {
    final user = _auth.currentUser;
    final texto = _notaCtrl.text.trim();
    if (user == null || texto.isEmpty) return;

    await _firestore.collection('anotacoes').add({
      'uid': user.uid,
      'texto': texto,
      'textoLower': texto.toLowerCase(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    _notaCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anotação salva')),
    );
  }

  Future<void> _editarAnotacao(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final controller = TextEditingController(text: data['texto'] ?? '');

    final novo = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar anotação'),
        content: TextField(
          controller: controller,
          minLines: 1,
          maxLines: 6,
          decoration: const InputDecoration(hintText: 'Atualize sua anotação'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Salvar')),
        ],
      ),
    );

    if (novo != null && novo.isNotEmpty) {
      await doc.reference.update({
        'texto': novo,
        'textoLower': novo.toLowerCase(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anotação atualizada')),
      );
    }
  }

  Future<void> _apagarAnotacao(DocumentSnapshot doc) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Apagar anotação'),
        content: const Text('Deseja apagar esta anotação?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Apagar')),
        ],
      ),
    );

    if (confirmar == true) {
      await doc.reference.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anotação apagada')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final termoLower = _termo.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dicas de Jogo'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Tópicos'),
            Tab(text: 'Minhas anotações'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: 'Pesquisar por palavra (título, resposta, anotação)...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _termo = '');
                  },
                ),
              ),
              onSubmitted: (v) => setState(() => _termo = v.trim()),
            ),
          ),

          // Conteúdo das abas
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _buildTopicos(termoLower),
                _buildAnotacoes(termoLower),
              ],
            ),
          ),

          // Campo para criar anotação (sempre visível para facilitar)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _notaCtrl,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Escreva uma anotação...',
                      prefixIcon: Icon(Icons.note_add),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _salvarAnotacao,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Abas

  Widget _buildTopicos(String termoLower) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('dicas').orderBy('topico').snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum tópico encontrado'));
        }

        final docs = snap.data!.docs;

        // Filtro de pesquisa (client-side) em tema, titulo e resposta
        final filtrados = docs.where((doc) {
          if (termoLower.isEmpty) return true;
          final data = doc.data() as Map<String, dynamic>? ?? {};
          final tema = (data['tema'] ?? '').toString().toLowerCase();
          final perguntas = List<Map<String, dynamic>>.from(data['perguntas'] ?? []);
          final hitTema = tema.contains(termoLower);
          final hitPerguntas = perguntas.any((p) {
            final t = (p['titulo'] ?? '').toString().toLowerCase();
            final r = (p['resposta'] ?? '').toString().toLowerCase();
            return t.contains(termoLower) || r.contains(termoLower);
          });
          return hitTema || hitPerguntas;
        }).toList();

        return ListView.builder(
          itemCount: filtrados.length,
          itemBuilder: (context, i) {
            final data = filtrados[i].data() as Map<String, dynamic>? ?? {};
            final tema = data['tema'] ?? '';
            final perguntas = List<Map<String, dynamic>>.from(data['perguntas'] ?? []);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ExpansionTile(
                title: Text(tema, style: const TextStyle(fontWeight: FontWeight.bold)),
                children: perguntas.map((p) {
                  return ListTile(
                    title: Text(p['titulo'] ?? ''),
                    subtitle: Text(p['resposta'] ?? ''),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAnotacoes(String termoLower) {
    final user = _auth.currentUser;
    if (user == null) {
      return const Center(child: Text('Faça login para ver e salvar anotações.'));
    }

    // Se há termo de pesquisa, filtramos client-side. Para limitar tráfego, filtramos por uid no servidor.
    final baseQuery = _firestore
        .collection('anotacoes')
        .where('uid', isEqualTo: user.uid)
        .orderBy('updatedAt', descending: true);

    return StreamBuilder<QuerySnapshot>(
      stream: baseQuery.snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return const Center(child: Text('Você ainda não possui anotações.'));
        }

        var docs = snap.data!.docs;

        if (termoLower.isNotEmpty) {
          docs = docs.where((d) {
            final data = d.data() as Map<String, dynamic>? ?? {};
            final texto = (data['texto'] ?? '').toString().toLowerCase();
            return texto.contains(termoLower);
          }).toList();
        }

        if (docs.isEmpty) {
          return const Center(child: Text('Nenhuma anotação corresponde à pesquisa.'));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>? ?? {};
            final texto = data['texto'] ?? '';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                title: Text(texto),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'editar') _editarAnotacao(doc);
                    if (v == 'apagar') _apagarAnotacao(doc);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'editar', child: Text('Editar')),
                    PopupMenuItem(value: 'apagar', child: Text('Apagar')),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
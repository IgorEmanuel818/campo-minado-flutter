import 'package:flutter/material.dart';
import '../controllers/tela_campo_minado_controller.dart';

class TelaCampoMinadoView extends StatefulWidget {
  const TelaCampoMinadoView({super.key});

  @override
  State<TelaCampoMinadoView> createState() => _TelaCampoMinadoViewState();
}

class _TelaCampoMinadoViewState extends State<TelaCampoMinadoView> {
  late final TelaCampoMinadoController controller;

  @override
  void initState() {
    super.initState();
    controller = TelaCampoMinadoController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campo Minado')),
      body: Column(
        children: [
          // Tabuleiro
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 300,
                height: 300,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: controller.cols,
                  ),
                  itemCount: controller.rows * controller.cols,
                  itemBuilder: (context, index) {
                    final r = index ~/ controller.cols;
                    final c = index % controller.cols;
                    final cell = controller.board[r][c];

                    return GestureDetector(
                      onTap: () {
                        controller.reveal(r, c);
                        setState(() {});
                      },
                      onDoubleTap: () {
                        controller.toggleFlag(r, c);
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: cell.revealed ? Colors.grey[300] : Colors.blue[200],
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(child: _buildCellContent(cell)),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Cronômetro
          if (controller.temporizadorAtivo)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Tempo: ${controller.elapsedSeconds}s",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

          // Mensagem de fim de jogo
          if (controller.gameOver)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                controller.victory ? 'Você ganhou 🎉' : 'Você perdeu 💣',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),

      // Botão voltar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Voltar'),
        ),
      ),

      // Botão recomeçar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.resetGame();
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildCellContent(Cell cell) {
    if (cell.flagged) {
      return const Icon(Icons.flag, color: Colors.red);
    }
    if (!cell.revealed) {
      return const SizedBox.shrink();
    }
    if (cell.hasBomb) {
      return const Icon(Icons.brightness_1, color: Colors.black);
    }
    if (cell.number > 0) {
      return Text(
        '${cell.number}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      );
    }
    return const SizedBox.shrink();
  }
}
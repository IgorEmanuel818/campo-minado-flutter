import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'tela_configuracoes_controller.dart';

class TelaCampoMinadoController extends ChangeNotifier {
  final int rows = 9;
  final int cols = 9;
  final int bombs = 10;

  late List<List<Cell>> board;
  bool gameOver = false;
  bool victory = false;

  // Temporizador
  Timer? _timer;
  int elapsedSeconds = 0;
  bool temporizadorAtivo = false;

  TelaCampoMinadoController() {
    _generateBoard();
    temporizadorAtivo = TelaConfiguracoesController().habilitarTemporizador;
  }

  void _generateBoard() {
    board = List.generate(rows, (r) => List.generate(cols, (c) => Cell()));
    _placeBombs();
    _calculateNumbers();
    gameOver = false;
    victory = false;
    elapsedSeconds = 0;
    _timer?.cancel();
    notifyListeners();
  }

  void _placeBombs() {
    final rand = Random();
    int placed = 0;
    while (placed < bombs) {
      final r = rand.nextInt(rows);
      final c = rand.nextInt(cols);
      if (!board[r][c].hasBomb) {
        board[r][c].hasBomb = true;
        placed++;
      }
    }
  }

  void _calculateNumbers() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!board[r][c].hasBomb) {
          int count = 0;
          for (int dr = -1; dr <= 1; dr++) {
            for (int dc = -1; dc <= 1; dc++) {
              final nr = r + dr, nc = c + dc;
              if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
                if (board[nr][nc].hasBomb) count++;
              }
            }
          }
          board[r][c].number = count;
        }
      }
    }
  }

  void _startTimer() {
    if (!temporizadorAtivo) return;
    if (_timer != null) return; // já está rodando
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds++;
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void reveal(int r, int c) {
    if (board[r][c].revealed || board[r][c].flagged || gameOver) return;

    // inicia o cronômetro no primeiro clique
    if (elapsedSeconds == 0) {
      _startTimer();
    }

    board[r][c].revealed = true;

    if (board[r][c].hasBomb) {
      gameOver = true;
      _stopTimer();
      notifyListeners();
      return;
    }

    if (board[r][c].number == 0) {
      for (int dr = -1; dr <= 1; dr++) {
        for (int dc = -1; dc <= 1; dc++) {
          final nr = r + dr, nc = c + dc;
          if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
            if (!board[nr][nc].revealed) reveal(nr, nc);
          }
        }
      }
    }

    _checkVictory();
    notifyListeners();
  }

  void toggleFlag(int r, int c) {
    if (board[r][c].revealed || gameOver) return;
    board[r][c].flagged = !board[r][c].flagged;
    notifyListeners();
  }

  void _checkVictory() {
    int revealedCount = 0;
    for (final row in board) {
      for (final cell in row) {
        if (cell.revealed) revealedCount++;
      }
    }
    if (revealedCount == rows * cols - bombs) {
      victory = true;
      gameOver = true;
      _stopTimer();
    }
  }

  void resetGame() {
    _generateBoard();
  }
}

class Cell {
  bool hasBomb = false;
  bool revealed = false;
  bool flagged = false;
  int number = 0;
}
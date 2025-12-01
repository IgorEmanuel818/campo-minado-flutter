import 'package:flutter/material.dart';

class TelaConfiguracoesController extends ChangeNotifier {
  bool habilitarTemporizador = false;

  void toggleTemporizador(bool value) {
    habilitarTemporizador = value;
    notifyListeners();
  }
}
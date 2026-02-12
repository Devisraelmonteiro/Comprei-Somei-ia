import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Simula delay de rede
      await Future.delayed(const Duration(seconds: 2));

      // Simulação básica de validação
      if (email.isEmpty || password.isEmpty) {
        errorMessage = 'Preencha todos os campos';
        isLoading = false;
        notifyListeners();
        return false;
      }

      // Sucesso
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Erro ao realizar login';
      notifyListeners();
      return false;
    }
  }
}

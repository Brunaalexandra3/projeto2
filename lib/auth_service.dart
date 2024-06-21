import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa o Firebase Auth para autenticação de utilizadores
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o Firestore para armazenamento de dados

// Serviço de autenticação com suporte a notificações de mudanças de estado
class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do Firebase Auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instância do Firestore
  User? _currentUser; // Utilizador atualmente autenticado

  // Getter para o utilizador atualmente autenticado
  User? get currentUser => _currentUser;

  // Construtor da classe AuthService
  AuthService() {
    // Listener para mudanças no estado de autenticação
    _auth.authStateChanges().listen((user) {
      _currentUser = user; // Atualiza o utilizador atual
      notifyListeners(); // Notifica os ouvintes sobre a mudança de estado
    });
  }

  // Método para registar um novo utilizador
  Future<void> signUp(String email, String password) async {
    try {
      // Cria um novo utilizador com email e senha
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _currentUser = userCredential.user; // Atualiza o utilizador atual
      // Adiciona o utilizador ao Firestore com email e pontuação inicial de 0
      await _firestore.collection('users').doc(_currentUser!.uid).set({
        'email': email,
        'score': 0,
      });
      notifyListeners(); // Notifica os ouvintes sobre a mudança de estado
    } on FirebaseAuthException catch (e) {
      // Trata erros de autenticação
      print('Erro ao registar: $e');
    }
  }

  // Método para fazer login de um utilizador existente
  Future<void> signIn(String email, String password) async {
    try {
      // Faz login com email e senha
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _currentUser = userCredential.user; // Atualiza o utilizador atual
      notifyListeners(); // Notifica os ouvintes sobre a mudança de estado
    } on FirebaseAuthException catch (e) {
      // Trata erros de autenticação
      print('Erro ao fazer login: $e');
    }
  }

  // Método para fazer logout do utilizador atual
  Future<void> signOut() async {
    await _auth.signOut(); // Faz logout
    _currentUser = null; // Define o utilizador atual como nulo
    notifyListeners(); // Notifica os ouvintes sobre a mudança de estado
  }
}

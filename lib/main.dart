import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa o Firebase core
import 'package:provider/provider.dart'; // Importa o Provider para gerenciamento de estado
import 'login_screen.dart'; // Importa a tela de login
import 'register_screen.dart'; // Importa a tela de registro
import 'game_screen.dart'; // Importa a tela do jogo
import 'score_screen.dart'; // Importa a tela de pontuação
import 'ranking_screen.dart'; // Importa a tela de ranking
import 'auth_service.dart'; // Importa o serviço de autenticação
import 'game_service.dart'; // Importa o serviço do jogo

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o Flutter esteja inicializado antes de rodar a aplicação
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(
    MultiProvider(
      providers: [
        // Provedor de estado para autenticação
        ChangeNotifierProvider(create: (_) => AuthService()),
        // Provedor de estado para o jogo
        ChangeNotifierProvider(create: (_) => GameService()),
      ],
      child: MyApp(), // Inicializa a aplicação principal
    ),
  );
}

// Classe principal da aplicação
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPv4 Educational game', // Título da aplicação
      theme: ThemeData(
        primarySwatch: Colors.purple, // Define a cor primária da aplicação
      ),
      home: Consumer<AuthService>(
        builder: (context, authService, _) {
          // Verifica se o usuário está autenticado
          if (authService.currentUser != null) {
            return GameScreen(); // Se estiver autenticado, mostra a tela do jogo
          } else {
            return LoginScreen(); // Se não estiver autenticado, mostra a tela de login
          }
        },
      ),
      routes: {
        // Define as rotas da aplicação
        '/register': (context) => RegisterScreen(), // Rota para a tela de registro
        '/game': (context) => GameScreen(), // Rota para a tela do jogo
        '/score': (context) => ScoreScreen(), // Rota para a tela de pontuação
        '/ranking': (context) => RankingScreen(), // Rota para a tela de ranking
      },
    );
  }
}

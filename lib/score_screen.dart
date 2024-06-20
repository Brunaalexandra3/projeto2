import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_service.dart';  // Serviço para manipular a lógica do jogo
import 'auth_service.dart';  // Serviço para autenticação de usuário
import 'custom_button.dart'; // Componente personalizado para botões

// Tela que exibe a pontuação do usuário
class ScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtém a pontuação passada como argumento para a tela
    final int score = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(title: Text('Your Score')), // Barra de aplicativo com título
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Exibe a pontuação do usuário
            Text('Your Score: $score', style: TextStyle(fontSize: 36)),
            SizedBox(height: 20), // Espaço entre os widgets
            // Botão para jogar novamente
            CustomButton(
              text: 'Play Again',
              onPressed: () {
                // Navega para a tela do jogo
                Navigator.pushNamed(context, '/game');
              },
            ),
            // Botão para visualizar o ranking
            CustomButton(
              text: 'View Ranking',
              onPressed: () {
                // Obtém o usuário atual do serviço de autenticação
                final currentUser = Provider.of<AuthService>(context, listen: false).currentUser;
                if (currentUser != null) {
                  // Se o usuário está autenticado, salva a pontuação no Firestore
                  Provider.of<GameService>(context, listen: false).saveScore(currentUser.uid, score).then((_) {
                    // Após salvar a pontuação, navega para a tela de ranking
                    Navigator.pushNamed(context, '/ranking');
                  });
                } else {
                  // Se o usuário não está autenticado, navega para a tela de login
                  Navigator.pushNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

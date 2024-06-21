import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_service.dart';  // Serviço para manipular a lógica do jogo
import 'auth_service.dart';  // Serviço para autenticação de utilizador

// Tela de exibição do ranking de pontuações
class RankingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking'), // Título da barra de aplicações
        actions: [
          // Consumidor para obter o serviço de autenticação
          Consumer<AuthService>(
            builder: (context, authService, _) {
              // Se o utilizador estiver autenticado, mostra o ícone de logout
              return authService.currentUser != null
                  ? IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        // Ao pressionar o botão de logout, desloga o utilizador e navega para a tela de login
                        authService.signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    )
                  : Container(); // Se não estiver autenticado, mostra um contêiner vazio
            },
          ),
        ],
      ),
      // Consumidor para obter o serviço do jogo
      body: Consumer<GameService>(
        builder: (context, gameService, child) {
          // Usa um StreamBuilder para construir a interface com base nos dados de pontuação
          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: gameService.getTopScores(), // Obtém os 5 melhores scores
            builder: (context, snapshot) {
              // Se o stream ainda está a carregar, mostra um indicador de progresso
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              // Se não há dados ou os dados estão vazios, mostra uma mensagem
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Sem pontuações disponíveis'));
              }

              final scores = snapshot.data!;
              // Constrói uma lista com as pontuações
              return ListView.builder(
                itemCount: scores.length, // Número de itens na lista
                itemBuilder: (context, index) {
                  final scoreData = scores[index];
                  return ListTile(
                    title: Text(scoreData['email']), // Email do utilizador
                    trailing: Text(scoreData['score'].toString()), // Pontuação do utilizador
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

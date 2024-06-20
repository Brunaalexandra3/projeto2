import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa o Provider para gerenciamento de estado
import 'question_model.dart'; // Importa o modelo de dados da questão
import 'game_service.dart'; // Importa o serviço do jogo
import 'auth_service.dart'; // Importa o serviço de autenticação
import 'custom_button.dart'; // Importa o componente personalizado para botões

// Tela principal do jogo
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Question> _questions = []; // Lista de perguntas
  int _currentQuestionIndex = 0; // Índice da pergunta atual
  int _score = 0; // Pontuação do usuário
  String _selectedDifficulty = 'Fácil'; // Dificuldade selecionada
  String? _feedbackMessage; // Mensagem de feedback após resposta

  @override
  void initState() {
    super.initState();
    _loadQuestions(); // Carrega as perguntas ao iniciar a tela
    _loadUserScore(); // Carrega a pontuação do usuário ao iniciar a tela
  }

  // Carrega as perguntas com base na dificuldade selecionada
  void _loadQuestions() {
    _questions = Provider.of<GameService>(context, listen: false).generateQuestions(_selectedDifficulty);
    setState(() {
      _currentQuestionIndex = 0; // Reinicia o índice da pergunta
      _feedbackMessage = null; // Reseta a mensagem de feedback
    });
  }

  // Carrega a pontuação do usuário atual
  void _loadUserScore() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final gameService = Provider.of<GameService>(context, listen: false);
    final currentUser = authService.currentUser;

    // Se o usuário está autenticado, carrega a pontuação
    if (currentUser != null) {
      gameService.getUserScore(currentUser.uid).then((userScore) {
        setState(() {
          _score = userScore; // Atualiza a pontuação no estado
        });
      });
    }
  }

  // Verifica a resposta do usuário e atualiza a pontuação
  void _checkAnswer(String answer) {
    bool isCorrect = _questions[_currentQuestionIndex].isCorrect(answer);
    int points = _getPoints(isCorrect);

    setState(() {
      _score += points; // Atualiza a pontuação
      _feedbackMessage = isCorrect ? 'Correct! +${points} points' : 'Incorrect! ${points} points'; // Define a mensagem de feedback
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUser = authService.currentUser;

    // Se o usuário está autenticado, salva a pontuação
    if (currentUser != null) {
      Provider.of<GameService>(context, listen: false).saveScore(currentUser.uid, _score);
    }

    // Atraso antes de passar para a próxima pergunta ou finalizar
    Future.delayed(Duration(seconds: 2), () {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++; // Próxima pergunta
          _feedbackMessage = null; // Reseta a mensagem de feedback
        });
      } else {
        Navigator.pushNamed(context, '/score', arguments: _score); // Navega para a tela de pontuação
      }
    });
  }

  // Calcula os pontos com base na dificuldade e se a resposta está correta
  int _getPoints(bool isCorrect) {
    switch (_selectedDifficulty) {
      case 'Fácil':
        return isCorrect ? 10 : -5;
      case 'Médio':
        return isCorrect ? 20 : -10;
      case 'Difícil':
        return isCorrect ? 30 : -15;
      default:
        return 0;
    }
  }

  // Define a dificuldade e carrega novas perguntas
  void _setDifficulty(String? difficulty) {
    if (difficulty != null) {
      setState(() {
        _selectedDifficulty = difficulty;
        _loadQuestions();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IPv4 Educational game'), // Título da barra de aplicativos
        actions: [
          // Botão de logout
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, '/login'); // Navega para a tela de login
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaçamento ao redor do corpo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Exibe a pergunta atual e o total de perguntas
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // Espaçamento vertical
            // Exibe o texto da pergunta
            Text(
              _questions[_currentQuestionIndex].questionText,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20), // Espaçamento vertical
            // Exibe as opções de resposta
            ..._questions[_currentQuestionIndex].options.map((option) {
              return CustomButton(
                text: option,
                onPressed: () => _checkAnswer(option),
              );
            }).toList(),
            SizedBox(height: 20), // Espaçamento vertical
            // Dropdown para selecionar o nível de dificuldade
            Text('Nível de Dificuldade', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedDifficulty,
              onChanged: _setDifficulty,
              items: ['Fácil', 'Médio', 'Difícil'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // Exibe a mensagem de feedback, se houver
            if (_feedbackMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _feedbackMessage!,
                  style: TextStyle(
                    fontSize: 18,
                    color: _feedbackMessage!.startsWith('Correct') ? Colors.green : Colors.red,
                  ),
                ),
              ),
            // Exibe a pontuação atual
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Score: $_score',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

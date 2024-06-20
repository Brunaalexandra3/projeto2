// Classe que representa uma questão do quiz
class Question {
  final String questionText; // Texto da questão
  final List<String> options; // Lista de opções de resposta
  final String correctAnswer; // Resposta correta

  // Construtor da classe Question, que inicializa os atributos
  Question({
    required this.questionText, // Texto da questão é obrigatório
    required this.options, // Lista de opções é obrigatória
    required this.correctAnswer, // Resposta correta é obrigatória
  });

  // Método que verifica se a resposta fornecida é correta
  bool isCorrect(String answer) {
    return answer == correctAnswer; // Retorna true se a resposta estiver correta, false caso contrário
  }
}

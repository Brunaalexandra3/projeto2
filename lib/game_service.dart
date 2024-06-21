import 'dart:math'; // Importa a biblioteca matemática para gerar números aleatórios
import 'package:flutter/material.dart'; // Importa o Flutter para a criação de interfaces
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o Firestore para armazenamento de dados
import 'question_model.dart'; // Importa o modelo de dados da questão

// Serviço de jogo que gere a lógica do jogo e interage com o Firestore
class GameService with ChangeNotifier {
  final Random _random = Random(); // Instância de Random para gerar números aleatórios
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instância do Firestore

  // Método para gerar perguntas com base no nível de dificuldade
  List<Question> generateQuestions(String difficulty) {
    List<Question> questions = [];

    // Gerar 10 perguntas com base no nível de dificuldade
    for (int i = 0; i < 10; i++) { 
      if (difficulty == 'Fácil') {
        questions.addAll(_generateLevel1Questions());
      } else if (difficulty == 'Médio') {
        questions.addAll(_generateLevel2Questions());
      } else if (difficulty == 'Difícil') {
        questions.addAll(_generateLevel3Questions());
      }
    }

    return questions; // Retorna a lista de perguntas geradas
  }

  // Método para gerar perguntas de nível 1 (Fácil)
  List<Question> _generateLevel1Questions() {
    List<Question> questions = [];
    String ip = _generateRandomIPv4Private(); // Gera um endereço IPv4 privado aleatório

    String networkId = _calculateNetworkId(ip, 24); // Calcula o Network ID para /24
    String broadcast = _calculateBroadcast(ip, 24); // Calcula o Broadcast para /24

    // Adiciona a pergunta sobre o Network ID
    questions.add(Question(
      questionText: 'Qual é o Network ID do endereço $ip/24?',
      options: _generateOptions(networkId),
      correctAnswer: networkId,
    ));

    // Adiciona a pergunta sobre o Broadcast
    questions.add(Question(
      questionText: 'Qual é o Broadcast do endereço $ip/24?',
      options: _generateOptions(broadcast),
      correctAnswer: broadcast,
    ));

    return questions; // Retorna a lista de perguntas geradas
  }

  // Método para gerar perguntas de nível 2 (Médio)
  List<Question> _generateLevel2Questions() {
    List<Question> questions = [];
    String ip = _generateRandomIPv4Private(); // Gera um endereço IPv4 privado aleatório
    int mask = _random.nextInt(8) + 16; // Gera uma máscara entre /16 e /23

    String networkId = _calculateNetworkId(ip, mask); // Calcula o Network ID com a máscara gerada
    String broadcast = _calculateBroadcast(ip, mask); // Calcula o Broadcast com a máscara gerada

    // Adiciona a pergunta sobre o Network ID
    questions.add(Question(
      questionText: 'Qual é o Network ID do endereço $ip/$mask?',
      options: _generateOptions(networkId),
      correctAnswer: networkId,
    ));

    // Adiciona a pergunta sobre o Broadcast
    questions.add(Question(
      questionText: 'Qual é o Broadcast do endereço $ip/$mask?',
      options: _generateOptions(broadcast),
      correctAnswer: broadcast,
    ));

    return questions; // Retorna a lista de perguntas geradas
  } 


  // Método para gerar perguntas de nível 3 (Difícil)
List<Question> _generateLevel3Questions() {
  List<Question> questions = [];
  String ip1 = _generateRandomIPv4Private(); // Gera o primeiro endereço IPv4 privado aleatório
  String ip2 = _generateRandomIPv4Private(); // Gera o segundo endereço IPv4 privado aleatório
  int mask = _random.nextInt(8) + 8; // Gera uma máscara entre /8 e /15

  bool sameNetwork = _isSameNetwork(ip1, ip2, mask); // Verifica se os IPs estão na mesma rede

  // Adiciona a pergunta sobre se os IPs estão na mesma rede
  questions.add(Question(
    questionText: 'Os endereços $ip1/$mask e $ip2/$mask estão no mesmo segmento de rede?',
    options: ['Sim', 'Não'],
    correctAnswer: sameNetwork ? 'Sim' : 'Não',
  ));

  return questions; // Retorna a lista de perguntas geradas
}

// Método para gerar um endereço IPv4 privado aleatório
String _generateRandomIPv4Private() {
  int firstOctet = _random.nextInt(3);
  if (firstOctet == 0) {
    return '10.${_random.nextInt(256)}.${_random.nextInt(256)}.${_random.nextInt(256)}';
  } else if (firstOctet == 1) {
    return '172.${16 + _random.nextInt(16)}.${_random.nextInt(256)}.${_random.nextInt(256)}';
  } else {
    return '192.168.${_random.nextInt(256)}.${_random.nextInt(256)}';
  }
}

// Método para calcular o Network ID de um endereço IP
String _calculateNetworkId(String ip, int mask) {
  List<int> octets = ip.split('.').map(int.parse).toList(); // Converte o IP numa lista de octetos
  int binaryIp = (octets[0] << 24) + (octets[1] << 16) + (octets[2] << 8) + octets[3]; // Converte o IP para binário
  int binaryMask = (0xFFFFFFFF << (32 - mask)) & 0xFFFFFFFF; // Converte a máscara para binário
  int binaryNetworkId = binaryIp & binaryMask; // Calcula o Network ID em binário
  return '${(binaryNetworkId >> 24) & 0xFF}.${(binaryNetworkId >> 16) & 0xFF}.${(binaryNetworkId >> 8) & 0xFF}.${binaryNetworkId & 0xFF}'; // Converte o Network ID para decimal
}

// Método para calcular o Broadcast de um endereço IP
String _calculateBroadcast(String ip, int mask) {
  List<int> octets = ip.split('.').map(int.parse).toList(); // Converte o IP numa lista de octetos
  int binaryIp = (octets[0] << 24) + (octets[1] << 16) + (octets[2] << 8) + octets[3]; // Converte o IP para binário
  int binaryMask = (0xFFFFFFFF << (32 - mask)) & 0xFFFFFFFF; // Converte a máscara para binário
  int binaryBroadcast = binaryIp | ~binaryMask; // Calcula o Broadcast em binário
  return '${(binaryBroadcast >> 24) & 0xFF}.${(binaryBroadcast >> 16) & 0xFF}.${(binaryBroadcast >> 8) & 0xFF}.${binaryBroadcast & 0xFF}'; // Converte o Broadcast para decimal
}

// Método para verificar se dois endereços IP estão na mesma rede
bool _isSameNetwork(String ip1, String ip2, int mask) {
  return _calculateNetworkId(ip1, mask) == _calculateNetworkId(ip2, mask); // Compara os Network IDs dos dois IPs
}

  // Método para gerar opções de resposta, incluindo a resposta correta
List<String> _generateOptions(String correctAnswer) {
  Set<String> options = {correctAnswer}; // Inicia o conjunto de opções com a resposta correta
  while (options.length < 4) { // Garante que haverá 4 opções
    String option = _generateRandomIPv4Private(); // Gera uma opção aleatória
    options.add(option); // Adiciona a opção ao conjunto
  }
  return options.toList()..shuffle(); // Converte o conjunto numa lista e embaralha
}

// Método para salvar a pontuação do utilizador no Firestore
Future<void> saveScore(String uid, int score) async {
  DocumentReference userDoc = _firestore.collection('users').doc(uid); // Referência ao documento do utilizador
  DocumentSnapshot userSnapshot = await userDoc.get(); // Obtém o documento do utilizador

  if (userSnapshot.exists) {
    int currentScore = userSnapshot['score']; // Obtém a pontuação atual do utilizador
    if (score > currentScore) {
      await userDoc.update({'score': score}); // Atualiza a pontuação se a nova for maior
    }
  }
}

// Método para obter a pontuação do utilizador do Firestore
Future<int> getUserScore(String uid) async {
  DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(uid).get(); // Obtém o documento do utilizador
  if (userSnapshot.exists) {
    return userSnapshot['score']; // Retorna a pontuação do utilizador
  }
  return 0; // Retorna 0 se o documento não existir
}

// Método para obter os 5 melhores scores dos utilizadores
Stream<List<Map<String, dynamic>>> getTopScores() {
  return _firestore
      .collection('users')
      .orderBy('score', descending: true) // Ordena por pontuação em ordem decrescente
      .limit(5) // Limita aos 5 melhores
      .snapshots() // Obtém os dados em tempo real
      .map((snapshot) => snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList()); // Converte os dados para uma lista de mapas
}


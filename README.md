IPv4 Educational Game
Descrição
IPv4 Educational Game é um aplicativo desenvolvido em Flutter com o objetivo de ajudar os jogadores a explorar e aprender mais sobre conceitos de Redes de Computadores, especificamente sobre endereçamento IPv4. O jogo gera automaticamente perguntas sobre Network ID, Broadcast, e verificação de endereços IPv4 no mesmo segmento de rede. As perguntas são classificadas em três níveis de dificuldade e os jogadores podem escolher o nível desejado para cada resposta.

Funcionalidades
Registro e Login de Usuários: Usuários devem se autenticar para responder perguntas e verificar suas pontuações.
Responder a Perguntas: Perguntas sobre endereçamento IPv4 são geradas automaticamente com base no nível de dificuldade escolhido.
Feedback Imediato: Após responder uma pergunta, o jogador recebe feedback imediato sobre o resultado.
Pontuação: Pontuação do jogador é atualizada em tempo real e associada ao login do jogador.
Ranking: Lista os 5 melhores scores. Usuários não autenticados podem visualizar o ranking.
Níveis de Dificuldade
Fácil: Perguntas sobre endereços IPv4 /8, /16 e /24.
Médio: Perguntas sobre sub-redes.
Difícil: Perguntas sobre super-redes.
Pontuação
Nível Fácil: +10 pontos por acertar, -5 pontos por errar.
Nível Médio: +20 pontos por acertar, -10 pontos por errar.
Nível Difícil: +30 pontos por acertar, -15 pontos por errar.
Tecnologias Utilizadas
Flutter: Framework para desenvolvimento do aplicativo.
Firebase Authentication: Serviço de autenticação para registro e login de usuários.
Firebase Firestore: Banco de dados para armazenar as pontuações dos usuários.

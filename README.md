# IPv4 Educational Game

# Descrição
IPv4 Educational Game é um aplicativo desenvolvido em Flutter com o objetivo de ajudar os jogadores a explorar e aprender mais sobre conceitos de Redes de Computadores, especificamente sobre endereçamento IPv4. O jogo gera automaticamente perguntas sobre Network ID, Broadcast, e verificação de endereços IPv4 no mesmo segmento de rede. As perguntas são classificadas em três níveis de dificuldade e os jogadores podem escolher o nível desejado para cada resposta.

# Funcionalidades

Registro e Login de Utilizadores: Utilizadores devem se autenticar para responder perguntas e verificar suas pontuações.
Responder a Perguntas: Perguntas sobre endereçamento IPv4 são geradas automaticamente com base no nível de dificuldade escolhido.
Feedback Imediato: Após responder uma pergunta, o jogador recebe feedback imediato sobre o resultado.
Pontuação: Pontuação do jogador é atualizada em tempo real e associada ao login do jogador.
Ranking: Lista os 5 melhores scores. Utilizadores não autenticados podem visualizar o ranking.

# Níveis de Dificuldade

Fácil: Perguntas sobre endereços IPv4 /8, /16 e /24.
Médio: Perguntas sobre sub-redes.
Difícil: Perguntas sobre super-redes.
Pontuação
Nível Fácil: +10 pontos por acertar, -5 pontos por errar.
Nível Médio: +20 pontos por acertar, -10 pontos por errar.
Nível Difícil: +30 pontos por acertar, -15 pontos por errar.

# Tecnologias Utilizadas

Flutter: Framework para desenvolvimento do aplicativo.
Firebase Authentication: Serviço de autenticação para registro e login de utilizadores.
Firebase Firestore: Base de dados para armazenar as pontuações dos utilizadores.

# Instalação e Configuração

# Pré-requisitos
Flutter SDK: Flutter Installation
Conta no Firebase: Firebase Console

# Uso
# Registro e Login
Ao abrir o aplicativo, verá a tela de login.
Se não tiver uma conta, clique em "Register" para criar uma.
Após se registrar ou fazer login, será direcionado para a tela principal do jogo.

# Ao jogar o Jogo
Escolha o nível de dificuldade.
Responda as perguntas sobre endereçamento IPv4.
Receba feedback imediato e veja sua pontuação atualizada em tempo real.

# Ver Ranking
Utilizadores não autenticados podem visualizar o ranking dos 5 melhores scores clicando em "View Ranking" na tela de login.

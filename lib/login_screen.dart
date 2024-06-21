import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa o Provider para gerenciamento de estado
import 'auth_service.dart'; // Importa o serviço de autenticação
import 'custom_textfield.dart'; // Importa o componente personalizado para campos de texto
import 'custom_button.dart'; // Importa o componente personalizado para botões

// Tela de login do utilizador
class LoginScreen extends StatelessWidget {
  // Controladores para os campos de email e senha
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Chave para o formulário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')), // Barra de aplicação com título
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaçamento ao redor do corpo
        child: Form(
          key: _formKey, // Define a chave para o formulário
          child: Column(
            children: [
              // Campo de texto personalizado para email
              CustomTextField(
                controller: emailController,
                hintText: 'Email', // Texto de dica para o campo
                validator: (value) {
                  // Validação do campo de email
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o seu email';
                  }
                  // Verifica se o email está no formato correto
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              // Campo de texto personalizado para senha
              CustomTextField(
                controller: passwordController,
                hintText: 'Password', // Texto de dica para o campo
                obscureText: true, // Oculta o texto digitado (para senhas)
                validator: (value) {
                  // Validação do campo de senha
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a sua password';
                  }
                  // Verifica se a senha tem pelo menos 6 caracteres
                  if (value.length < 6) {
                    return 'A password deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              // Botão personalizado para login
              CustomButton(
                text: 'Login',
                onPressed: () {
                  // Verifica se o formulário é válido
                  if (_formKey.currentState!.validate()) {
                    // Chama o método de login do serviço de autenticação
                    Provider.of<AuthService>(context, listen: false).signIn(
                      emailController.text,
                      passwordController.text,
                    );
                  }
                },
              ),
              // Botão de texto para navegar para a tela de registo
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Registo'),
              ),
              // Botão de texto para visualizar o ranking
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ranking');
                },
                child: Text('Ver Ranking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

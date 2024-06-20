import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';  // Serviço para autenticação de usuário
import 'custom_textfield.dart';  // Componente personalizado para campos de texto
import 'custom_button.dart';  // Componente personalizado para botões

// Tela de registro de usuário
class RegisterScreen extends StatelessWidget {
  // Controladores para os campos de email e senha
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Chave para o formulário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')), // Barra de aplicativo com título
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
                    return 'Por favor, insira seu email';
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
                    return 'Por favor, insira sua password';
                  }
                  // Verifica se a senha tem pelo menos 6 caracteres
                  if (value.length < 6) {
                    return 'A password deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              // Botão personalizado para registro
              CustomButton(
                text: 'Register',
                onPressed: () {
                  // Verifica se o formulário é válido
                  if (_formKey.currentState!.validate()) {
                    // Chama o método de registro do serviço de autenticação
                    Provider.of<AuthService>(context, listen: false).signUp(
                      emailController.text,
                      passwordController.text,
                    );
                  }
                },
              ),
              // Botão de texto para navegar para a tela de login
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

// Componente personalizado para um campo de texto
class CustomTextField extends StatelessWidget {
  // Controlador para gerenciar o texto do campo
  final TextEditingController controller;
  // Texto de dica a ser exibido no campo
  final String hintText;
  // Indica se o texto do campo deve ser oculto (útil para senhas)
  final bool obscureText;
  // Função de validação opcional para o campo
  final String? Function(String?)? validator;

  // Construtor da classe CustomTextField
  CustomTextField({
    required this.controller, // Controlador é obrigatório
    required this.hintText, // Texto de dica é obrigatório
    this.obscureText = false, // obscureText é opcional, padrão é false
    this.validator, // Função de validação é opcional
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Define o controlador do campo de texto
      controller: controller,
      // Define se o texto do campo deve ser oculto
      obscureText: obscureText,
      // Configurações de decoração do campo de texto
      decoration: InputDecoration(
        hintText: hintText, // Texto de dica
        border: OutlineInputBorder(), // Borda do campo de texto
      ),
      // Função de validação para o campo de texto
      validator: validator,
    );
  }
}

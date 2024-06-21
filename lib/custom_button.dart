import 'package:flutter/material.dart';

// Componente personalizado para um botão
class CustomButton extends StatelessWidget {
  // Texto a ser exibido no botão
  final String text;
  // Função a ser chamada quando o botão for pressionado
  final VoidCallback onPressed;

  // Construtor da classe CustomButton
  CustomButton({
    required this.text, // O texto do botão é obrigatório
    required this.onPressed, // A função de callback é obrigatória
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Define a função a ser chamada quando o botão for pressionado
      onPressed: onPressed,
      // Define o texto a ser exibido no botão
      child: Text(text),
    );
  }
}


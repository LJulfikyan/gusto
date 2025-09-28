import 'package:flutter/material.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tarjetas'),
      ),
      body: const Center(
        child: Text('Acá se mostrarán las tarjetas del usuario.'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _pageController = PageController();

  void _showPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildLogin(context),
          _buildSignUp(context),
        ],
      ),
    );
  }

  Widget _buildLogin(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Iniciar Sesión', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).login();
              },
              child: const Text('Ingresar'),
            ),
            TextButton(
              onPressed: () => _showPage(1),
              child: const Text('No tenés cuenta? Registrate'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Registrarse', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                 Provider.of<AuthProvider>(context, listen: false).login();
              },
              child: const Text('Registrarse'),
            ),
            TextButton(
              onPressed: () => _showPage(0),
              child: const Text('Ya tenés cuenta? Ingresá'),
            ),
          ],
        ),
      ),
    );
  }
}

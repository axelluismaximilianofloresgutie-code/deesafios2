
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmarController =
  TextEditingController();

  bool _cargando = false;
  String? _error;

  Future<void> registrar() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmar = _confirmarController.text;

    if (email.isEmpty || password.isEmpty || confirmar.isEmpty) {
      setState(() {
        _error = 'Completá todos los campos.';
      });
      return;
    }

    if (password != confirmar) {
      setState(() {
        _error = 'Las contraseñas no coinciden.';
      });
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      await _authService.registrar(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          _error = 'Este correo ya está registrado.';
        } else if (e.code == 'weak-password') {
          _error = 'La contraseña debe tener al menos 6 caracteres.';
        } else if (e.code == 'invalid-email') {
          _error = 'El correo electrónico no es válido.';
        } else {
          _error = 'No se pudo registrar. Intentá nuevamente.';
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Ocurrió un error al crear la cuenta.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_add,
                size: 80,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              const Text(
                'Registrarse',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: _confirmarController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),

              const SizedBox(height: 15),

              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cargando ? null : registrar,
                  child: _cargando
                      ? const CircularProgressIndicator()
                      : const Text('Crear cuenta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

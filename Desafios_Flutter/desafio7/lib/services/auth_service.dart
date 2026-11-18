import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener el usuario que inició sesión.
  User? get usuarioActual => _auth.currentUser;

  // Detectar cambios en la sesión.
  Stream<User?> get cambiosSesion => _auth.authStateChanges();

  // Registrar un usuario.
  Future<UserCredential> registrar({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Iniciar sesión.
  Future<UserCredential> iniciarSesion({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Cerrar sesión.
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }
}
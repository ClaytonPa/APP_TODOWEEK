import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'todo_home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return const ToDoHome();
        } else {
          return const AuthFormSwitcher();
        }
      },
    );
  }
}

class AuthFormSwitcher extends StatefulWidget {
  const AuthFormSwitcher({super.key});

  @override
  State<AuthFormSwitcher> createState() => _AuthFormSwitcherState();
}

class _AuthFormSwitcherState extends State<AuthFormSwitcher> {
  bool showLogin = true;

  void toggleForm() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginForm(onSwitch: toggleForm)
        : RegisterForm(onSwitch: toggleForm);
  }
}

class LoginForm extends StatefulWidget {
  final VoidCallback onSwitch;
  const LoginForm({super.key, required this.onSwitch});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  String? error;

  Future<void> _login() async {
    setState(() => error = null);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
    } catch (_) {
      setState(() => error = 'Usuario o contraseña incorrectos');
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => error = null);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (_) {
      setState(() => error = 'No se pudo iniciar sesión con Google');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthContainer(
      title: 'Iniciar sesión',
      emailController: emailController,
      passController: passController,
      error: error,
      onPrimaryAction: _login,
      onGoogleAction: _loginWithGoogle,
      switchText: '¿No tienes cuenta? Regístrate aquí',
      onSwitch: widget.onSwitch,
      primaryButtonText: 'Entrar',
      googleButtonText: 'Entrar con Google',
    );
  }
}

class RegisterForm extends StatefulWidget {
  final VoidCallback onSwitch;
  const RegisterForm({super.key, required this.onSwitch});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  String? error;

  Future<void> _register() async {
    setState(() => error = null);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
    } catch (_) {
      setState(() => error = 'No se pudo registrar');
    }
  }

  Future<void> _registerWithGoogle() async {
    setState(() => error = null);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (_) {
      setState(() => error = 'No se pudo registrar con Google');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthContainer(
      title: 'Registrarse',
      emailController: emailController,
      passController: passController,
      error: error,
      onPrimaryAction: _register,
      onGoogleAction: _registerWithGoogle,
      switchText: '¿Ya tienes cuenta? Inicia sesión aquí',
      onSwitch: widget.onSwitch,
      primaryButtonText: 'Registrar',
      googleButtonText: 'Registrarse con Google',
    );
  }
}

class AuthContainer extends StatelessWidget {
  final String title;
  final TextEditingController emailController;
  final TextEditingController passController;
  final String? error;
  final VoidCallback onPrimaryAction;
  final VoidCallback onGoogleAction;
  final String switchText;
  final VoidCallback onSwitch;
  final String primaryButtonText;
  final String googleButtonText;

  const AuthContainer({
    super.key,
    required this.title,
    required this.emailController,
    required this.passController,
    required this.error,
    required this.onPrimaryAction,
    required this.onGoogleAction,
    required this.switchText,
    required this.onSwitch,
    required this.primaryButtonText,
    required this.googleButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(28),
            width: 340,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Correo'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: onPrimaryAction,
                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 44),
                        elevation: 4,
                        shadowColor: Colors.deepPurpleAccent,
                      ).copyWith(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.deepPurple.shade700;
                            }
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.deepPurple.shade800;
                            }
                            return null;
                          },
                        ),
                      ),
                  child: Text(
                    primaryButtonText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  icon: Image.asset('assets/google_logo.png', height: 20),
                  label: Text(googleButtonText),
                  onPressed: onGoogleAction,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(onPressed: onSwitch, child: Text(switchText)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

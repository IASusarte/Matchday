import 'package:flutter/material.dart';
import 'signup_view.dart';
import 'home_view.dart';
//import '../data/test_data.dart';
import '../data/session.dart';
import '../api/auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}
class _LoginViewState extends State<LoginView> {


  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenido',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  filled: true,
                  fillColor: const Color(0xFF5850EC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  filled: true,
                  fillColor: const Color(0xFF5850EC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  //print("Botón presionado");
                  final res = await AuthApi.login(
                    emailController.text, 
                    passController.text);

                  if (!context.mounted) return;

                  if(res != null && 
                     res["ok"] == true){
                  
                  Session.usuarioId = res["id"];
                     
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeView(),
                    ),
                  );
                } else {
                  final mensaje = res?["mensaje"]??
                  "Error de conexión";
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(
                      mensaje
                    ),
                    ),
                  );
                }
                },
                child: const Text('Iniciar sesión'),
              
            
              ),
              
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterView(),
                    ),
                  );
                },
                child: const Text(
                  '¿No tienes cuenta? Regístrate aquí',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
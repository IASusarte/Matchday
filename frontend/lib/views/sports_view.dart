import 'package:flutter/material.dart';
import 'package:proyecto_titulo/api/api_sports.dart';
import 'login_view.dart';
import '../api/api_user.dart';
import '../data/session.dart';
import '../data/data_temp.dart';
//import 'home_view.dart';

class SportsView extends StatefulWidget {
  const SportsView({super.key});

  @override
  State<SportsView> createState() => _SportsViewState();
}

class _SportsViewState extends State<SportsView> {

  String obtenerImagen(int idDeporte) {

    switch (idDeporte) {
      case 1:
        return 'assets/images/futbol.png';
      case 2:
        return 'assets/images/tenis.png';
      case 3:
        return 'assets/images/basquet.png';
      case 4:
        return 'assets/images/volei.png';
      default:
        return 'assets/images/futbol.png';
    }
  }

  List<dynamic> deportes = [];
  List<int> seleccionados = [];

  Future<void> finalizarRegistro() async {
      if (seleccionados.isEmpty) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Debe seleccionar al menos un deporte",
        ),
      ),
    );

    return;
  }

  try{


  final usuario =
      await UserApi.crearUsuario(
        rut: RegistroTemp.rut!,
        nombres: RegistroTemp.nombres!,
        apellidos: RegistroTemp.apellidos!,
        email: RegistroTemp.email!,
        nickname: RegistroTemp.nickname!,
        password: RegistroTemp.password!,
        fechaNacimiento: RegistroTemp.fechaNacimiento!,
        sexo: RegistroTemp.sexo!,
  );

  if (!mounted) return;

  if (usuario == null) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "No fue posible conectar con el servidor"
        ),
      ),
    );

    return;
  }
  

  if (usuario["ok"] == false) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          usuario["mensaje"]
        ),
      ),
    );

    return;
  }

  final idUsuario = usuario["id"];

  for (final idDeporte in seleccionados) {

    await UserApi.agregarPreferencia(
      idUsuario,
      idDeporte,
    );
  }

  Session.usuarioId = idUsuario;

  if (!mounted) return;
  if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Registro exitoso. Inicie sesión.',
        ),
      ),
    );

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginView(),
    ),
    (route) => false,
  );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
      "Error: $e"
    )));
  }
  }


  @override
  void initState() {
    super.initState();
    cargarDeportes();
  }

  Future<void> cargarDeportes() async {
    final data = await ApiSports.obtenerDeportes();
    setState(() {
      deportes = data;
    });
  }



  //bool futbol = false;
  //bool tenis = false;
  //bool basquet = false;
  //bool voleibol = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 40),

            const Text(
              'Registro de usuario',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            SizedBox(
                height: 500,

            
                child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                      children: deportes.map((deporte) {

                        return Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                obtenerImagen(
                                  deporte["id"],
                                ),
                                width: 90,
                                height: 90,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                deporte["nombre"],
                              ),
                              Checkbox(
                                value: seleccionados.contains(
                                  deporte["id"],
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      seleccionados.add(
                                        deporte["id"],
                                      );
                                    } else {
                                      seleccionados.remove(
                                        deporte["id"],
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
              ),
            ),

            ElevatedButton(
              onPressed: finalizarRegistro,
              
              child: const Text('Registrar'),
              
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

Widget deporteCard(
  String imagen,
  bool value,
  Function(bool?) onChanged,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset(
        imagen,
        width: 90,
        height: 90,
        fit: BoxFit.contain,
      ),
      Checkbox(
        value: value,
        onChanged: onChanged,
      ),
    ],
  );
}
}
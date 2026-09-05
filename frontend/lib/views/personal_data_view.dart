import 'package:flutter/material.dart';
import '../data/session.dart';
import '../api/api_user.dart';

class PersonalDataView extends StatefulWidget {
  const PersonalDataView({super.key});

  @override
  State<PersonalDataView> createState() => 
      _PersonalDataViewState();

}

class _PersonalDataViewState extends State<PersonalDataView>{
  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  final emailController = TextEditingController();
  final nicknameController = TextEditingController();
  final rutController = TextEditingController();
  final passwordPerfilController = TextEditingController();
  final passwordActualController = TextEditingController();
  final passwordNuevaController = TextEditingController();
  final passwordConfirmarController = TextEditingController();

  Map<String, dynamic>? usuario;
  Map<String, dynamic>? dashboard;

  Future<void> cargarUsuario() async {
    final data = await UserApi.obtenerUsuario(Session.usuarioId!);
      if (data == null) return;
      setState(() {
        usuario = data;
        nombresController.text = data["nombres"];
        apellidosController.text = data["apellidos"];
        emailController.text = data["email"];
        nicknameController.text = data["nickname"];
        rutController.text = data["rut"];
      });
  }
  Future<void> cargarDashboard() async {
    final data = await UserApi.obtenerDashboard(Session.usuarioId!);
    if (data == null) return;
    setState(() {
      dashboard = data;
    });
  }
  

  @override
  void initState() {
    super.initState();
    cargarUsuario();
    cargarDashboard();
  }
  

  @override
  Widget build(BuildContext context) {


    if(usuario == null || dashboard == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } 

    final compromiso = (dashboard!["promedio_compromiso"] ?? 0).toDouble();
    final puntualidad = (dashboard!["promedio_puntualidad"] ?? 0).toDouble();
    final fairplay = (dashboard!["promedio_fairplay"] ?? 0).toDouble();
    final nivelJuego = (dashboard!["promedio_nivel_juego"] ?? 0).toDouble();
    final reputacionGeneral =
                (compromiso +
                puntualidad +
                fairplay +
                nivelJuego) / 4;
    
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        elevation: 0,
        title: const Text('Datos personales'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              'Datos personales',
              style: TextStyle(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            

            _campo('Nombres', valor: usuario?["nombres"] ?? ''),
            _campo('Apellidos', valor: usuario?["apellidos"] ?? ''),
            _campoEditable('Correo', emailController),
            _campoEditable('Nickname', nicknameController),
            _campo('RUT', valor: usuario?["rut"] ?? ''),
            _campo('Fecha nacimiento', valor: usuario?["fecha_nacimiento"] ?? ''),
            _campo('Sexo', valor: usuario?["sexo"] ?? ''),
            _campoPassword('Contraseña actual', passwordPerfilController,),

            ElevatedButton(
              onPressed: () async {

                final emailRegex = RegExp(
                   r'^[^@]+@[^@]+\.[^@]+$',
                );

                if (
                  !emailRegex.hasMatch(
                    emailController.text,
                  )
                ) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe ingresar un correo válido",
                      ),
                    ),
                  );

                  return;
                }

                if (
                  nicknameController.text.trim().isEmpty
                ) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe ingresar un nickname",
                      ),
                    ),
                  );

                  return;
                }

                if (
                  passwordPerfilController.text.isEmpty
                ) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe ingresar su contraseña actual",
                      ),
                    ),
                  );

                  return;
                }

                final confirmar = await showDialog<bool>(
                  context: context,
                  builder: (context) {

                return AlertDialog(
                  title: const Text("Confirmar cambios"),
                  content: const Text("¿Desea guardar los cambios realizados?"),
                actions: [

                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        false
                      );
                    },
                    child: const Text("Cancelar"),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        true
                      );
                    },
                    child: const Text("Guardar"),
                  ),

                ],
                );

                },
                );

                if (confirmar != true) {
                  return;
                }

                final res = await UserApi.actualizarPerfil(
                  Session.usuarioId!,
                  emailController.text,
                  nicknameController.text,
                  passwordPerfilController.text,
                );

                if (!context.mounted) return;

                if (res?["ok"] == false){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                      'No fue posible actualizar los datos'
                      ),
                    ),
                  );
                  return;             
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      res?["mensaje"] ??
                      "Datos actualizados",
                    ),
                  ),
                );

              },
              child: const Text(
                'Guardar perfil',
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Reestablecer contraseña',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),

            const SizedBox(height: 20),

            _campoPassword('Contraseña actual', passwordActualController),
            _campoPassword('Nueva contraseña', passwordNuevaController),
            _campoPassword('Confirmar contraseña', passwordConfirmarController),

            ElevatedButton(
              onPressed: () async {

                if (
                  passwordActualController.text.isEmpty ||
                  passwordNuevaController.text.isEmpty ||
                  passwordConfirmarController.text.isEmpty
                ) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe completar todos los campos"
                      ),
                    ),
                  );

                  return;
                }

                if (
                  passwordNuevaController.text !=
                  passwordConfirmarController.text
                ) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Las contraseñas no coinciden"
                      ),
                    ),
                  );

                  return;
                }

                final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).{8,}$');

                if (
                  !passwordRegex.hasMatch(
                    passwordNuevaController.text,
                  )
                ) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "La nueva contraseña debe tener al menos 8 caracteres, una mayúscula y un número",
                      ),
                    ),
                  );

                  return;
                }

                final confirmar = await showDialog<bool>(
                  context: context,
                  builder: (context) {

                    return AlertDialog(
                      title: const Text(
                        "Confirmar cambio",
                      ),
                      content: const Text(
                        "¿Desea actualizar su contraseña?",
                      ),
                      actions: [

                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              false,
                            );
                          },
                          child: const Text(
                            "Cancelar",
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              true,
                            );
                          },
                          child: const Text(
                            "Aceptar",
                          ),
                        ),

                      ],
                    );

                  },
                );

                if (confirmar != true) {
                  return;
                }

                final res =
                    await UserApi.cambiarPassword(
                  Session.usuarioId!,
                  passwordActualController.text,
                  passwordNuevaController.text,
                );

                if (!context.mounted) return;

                if (res?["ok"] == false) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      "No fue posible actualizar el perfil"
                    ),
                  ),
                );
                return;

              }

              passwordActualController.clear();
              passwordNuevaController.clear();
              passwordConfirmarController.clear();

              ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      "Contraseña actualizada correctamente"
                    ),
                  ),
              );



              },
              child: const Text(
                'Actualizar contraseña',
              ),
            ),
  

            const SizedBox(height: 30),

            Text(
                  'Partidas creadas: ${dashboard!["partidas_creadas"]}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),

            const Text(
              'Reputación',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),



            Text('General: ${reputacionGeneral.toStringAsFixed(1)} ⭐'),
            Text('Compromiso: $compromiso ⭐'),
            Text('Puntualidad : $puntualidad ⭐'),
            Text('FairPlay: $fairplay ⭐'),
            Text('Nivel de Juego: $nivelJuego ⭐')

          ],
        ),
      ),
    );
  }

  static Widget _campo(
    String texto,
    {String? valor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: TextEditingController(text: valor),
        readOnly: true,
        decoration: InputDecoration(
          labelText: texto,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

  Widget _campoEditable(
    String texto,
    TextEditingController controller
    ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: texto,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _campoPassword(
  String texto,
  TextEditingController controller,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: texto,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}

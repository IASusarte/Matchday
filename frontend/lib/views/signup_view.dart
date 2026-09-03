import 'package:flutter/material.dart';
import 'sports_view.dart';
import '../data/data_temp.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
  }

  class _RegisterViewState extends State<RegisterView> {

  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  final emailController = TextEditingController();
  final nicknameController = TextEditingController();
  final rutController = TextEditingController();
  final fechaController = TextEditingController();
  String? sexoSeleccionado;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nombresController.dispose();
    apellidosController.dispose();
    emailController.dispose();
    nicknameController.dispose();
    rutController.dispose();
    fechaController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          
          children: [
            const SizedBox(height: 40),

            const Text(
              'Registro de usuario',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
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

            const SizedBox(height: 30),

            _campo('Nombres', nombresController, 'Juan José'),
            _campo('Apellidos', apellidosController, 'Silva González'),
            _campo('Correo', emailController, 'jjsilva@mail.cl'),
            _campo('Nickname', nicknameController, 'juanito01'),
            _campo('RUT', rutController, '12.345.678-k'),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextField(
                controller: fechaController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  hintText: 'Seleccione una fecha',
                 filled: true,
                 fillColor: const Color(0xFF5850EC),
                 border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onTap: () async {
                final fecha = await showDatePicker(
                  context: context, 
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900), 
                  lastDate: DateTime.now()
                );
                if (fecha != null){
                  fechaController.text =
                    fecha.toIso8601String().split('T').first;

                }
              }
              ),
            ),            
            //_campo('Fecha de nacimiento', fechaController, '2000-12-31'),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<String>(
                initialValue: sexoSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Sexo',
                 filled: true,
                 fillColor: const Color(0xFF5850EC),
                 border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Masculino',
                  child: Text('Masculino'),
                ),
                DropdownMenuItem(
                  value: 'Femenino',
                  child: Text('Femenino'),
                ),
                DropdownMenuItem(
                  value: 'Prefiero no indicar',
                  child: Text('Prefiero no indicar'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  sexoSeleccionado = value;
                  });
                },
              ),
            ),
            _campo('Contraseña', passwordController, 'Mínimo 8 caracteres, al menos 1 mayúscula y un número',
            ocultar: true),
            _campo('Confirmar contraseña', confirmPasswordController, 'Repetir contraseña aquí',
            ocultar: true),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                RegistroTemp.nombres = nombresController.text;
                RegistroTemp.apellidos = apellidosController.text;
                RegistroTemp.email = emailController.text;
                RegistroTemp.nickname = nicknameController.text;
                RegistroTemp.rut = rutController.text;
                RegistroTemp.fechaNacimiento = fechaController.text;
                RegistroTemp.sexo = sexoSeleccionado;
                RegistroTemp.password = passwordController.text;

                if(nombresController.text.trim().isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe ingresar sus nombres"

                      ),
                    ),
                  );
                  return;
                }
                if(apellidosController.text.trim().isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe ingresar sus apellidos"

                      ),
                    ),
                  );

                  return;
                }
                if(emailController.text.trim().isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe ingresar un correo electrónico"

                      ),
                    ),
                  );

                  return;
                }
                if(nicknameController.text.trim().isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe ingresar un nickname o apodo"

                      ),
                    ),
                  );
                  return;

                }
                if(rutController.text.trim().isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe ingresar su RUT"

                      ),
                    ),
                  );
                  return;
                }
                if(fechaController.text.trim().isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe ingresar su fecha de nacimiento"

                      ),
                    ),
                  );
                  return;
                }
                if(sexoSeleccionado == null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe seleccionar su sexo"

                      ),
                    ),
                  );
                  return;
                }
                if(passwordController.text.trim().isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe ingresar una contraseña"

                      ),
                    ),
                  );
                  return;
                }


                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                if (!emailRegex.hasMatch(emailController.text)) 
                  {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                      "Ingresa formato de correo valido. Ej: usuario@123.cl"
                      )
                    )
                  );
                  return;
                }

                final rutRegex = RegExp(r'^\d{1,2}\.\d{3}\.\d{3}-[\dkK]$');
                if (!rutRegex.hasMatch(rutController.text)) 
                  {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                      "El RUT debe tener formato 12.345.678-9"
                      )
                    )
                  );
                  return;
                }

                final fechaRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');

                if (
                  !fechaRegex.hasMatch(fechaController.text)
                ) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "la fecha debe tener formato YYYY-MM-DD"
                      ),
                    ),
                  );

                  return;
                }

                final fechaNacimiento = DateTime.parse(fechaController.text);
                int edad = DateTime.now().year - fechaNacimiento.year;
                if(
                  DateTime.now().month <
                  fechaNacimiento.month ||
                  (
                  DateTime.now().month ==
                  fechaNacimiento.month &&
                  DateTime.now().day <
                  fechaNacimiento.day                                      
                  )
                ){
                  edad--;
                }

                if (edad < 14) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe tener al menos 14 años para registrarse"
                      ),
                    ),
                  );

                  return;
                }


                if (
                    passwordController.text != confirmPasswordController.text
                ) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Las contraseñas no coinciden",
                      ),
                    ),
                  );

                  return;
                }

                final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).{8,}$',);

                if (
                    !passwordRegex.hasMatch(
                      passwordController.text
                    )
                ) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "La contraseña debe contener al menos 8 caracteres, una mayuscula y un número"

                      ),
                    ),
                  );

                  return;
                }


              

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SportsView(),
                  ),
                );
              },
              child: const Text('Siguiente'),
            )
          ],
        ),
      ),
    );
  }

  Widget _campo(
    String texto,
    TextEditingController controller,
    String ayuda,
    {bool ocultar = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: ocultar,
        decoration: InputDecoration(
          labelText: texto,
          hintText: ayuda,
          filled: true,
          fillColor: const Color(0xFF5850EC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
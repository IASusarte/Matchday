import '../models/partida.dart';
import '../models/usuario.dart';
import '../models/evaluacion.dart';
import '../models/deporte.dart';
import '../models/preferencia_deporte.dart';
import '../models/participante_partida.dart';
import '../models/solicitud.dart';

List<Partida> testPartidas = [];
List<Usuario> testUsuarios = [];
List<Evaluacion> testEvaluaciones = [];
List<Deporte> testDeportes = [];
List<PreferenciaDeporte> testPreferencias = [];
List<ParticipantePartida> testParticipantes = [];
List<Solicitud> testSolicitudes = [];

Usuario demo = Usuario(
  id: 1,
  rut: '12345678-9',
  nombres: 'Ignacio',
  apellidos: 'Susarte',
  email: 'ignacio@demo.com',
  nickname: 'ignacio123',
  password: 'hola123',
  fechaNacimiento: DateTime(1994, 7, 15),
  sexo: 'Masculino',
);
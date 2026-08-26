import '../data/test_data.dart';
import '../models/usuario.dart';

class UsuarioRepo {
  List<Usuario> obtenerUsuarios() {
    return testUsuarios;
  }

  Usuario? obtenerId(int id){

    try{
      return testUsuarios.firstWhere(
        (u) => u.id == id
      );
    } catch (_){
      return null;
    }
  }
}
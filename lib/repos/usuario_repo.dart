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

  void actualizarUsuario(
    Usuario usuario
  ){
    final indice = testUsuarios.indexWhere(
      (u) => u.id == usuario.id
    );
    if (indice != -1){
      testUsuarios[indice] = usuario;
    }
  }
}
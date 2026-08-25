class Usuario {
  final int id;
  String rut;
  String nombres;
  String apellidos;
  String email;
  String nickname;
  final String password;
  final DateTime fechaNacimiento;
  final String sexo;

  Usuario({
    required this.id,
    required this.rut,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.nickname,
    required this.password,
    required this.fechaNacimiento,
    required this.sexo,
  });

}
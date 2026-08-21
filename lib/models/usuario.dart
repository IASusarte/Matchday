class Usuario {
  final int id;
  final String rut;
  final String nombres;
  final String apellidos;
  final String email;
  final String nickname;
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
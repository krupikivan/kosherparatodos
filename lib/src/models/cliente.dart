class Cliente{

  String email;
  String name;
  String idCliente;

  Cliente.fromMap(Map<String, dynamic> data, id){
    email = data['email'];
    name = data['name'];
    idCliente = id;
  }
}
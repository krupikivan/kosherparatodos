class Cliente{

  String email;
  String nombre;
  String clienteID;

  Cliente.fromMap(Map<String, dynamic> data, id){
    email = data['email'];
    nombre = data['name'];
    clienteID = id;
  }

  Cliente.fromPedidos(Map<String, dynamic> data){
    clienteID = data['cliente']['clienteID'];
    nombre = data['cliente']['nombre'];
  }
}
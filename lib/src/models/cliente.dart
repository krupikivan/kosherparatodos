class Cliente{

  String email;
  Nombre nombre;
  String clienteID;
  Direccion direccion;
  int telefono;
  bool estaAutenticado;

  Cliente.fromMap(Map<String, dynamic> data, id){
    email = data['email'];
    telefono = data['telefono'];
    estaAutenticado = data['estaAutenticado'];
    nombre = Nombre.fromMap(data['nombre']);
    direccion = Direccion.fromMap(data['direccion']);
    clienteID = id;
  }

  Cliente.fromPedidos(Map<String, dynamic> data){
    clienteID = data['cliente']['clienteID'];
    nombre = Nombre.fromMap(data['cliente']['nombre']);
  }
}

class Nombre{
  String nombre;
  String apellido;

  Nombre.fromMap(Map<String, dynamic> data){
    nombre = data['nombre'];
    apellido = data['apellido'];
  }
}

class Direccion{

  String aclaracion;
  String calle;
  String ciudad;
  int codigoPostal;
  int numero;
  int piso;
  String provincia;

  Direccion.fromMap(Map<String, dynamic> data){
    aclaracion = data['aclaracion'];
    calle = data['calle'];
    ciudad = data['ciudad'];
    codigoPostal = data['codigoPostal'].toInt();
    numero = data['numero'].toInt();
    piso = data['piso'].toInt();
    provincia = data['provincia'];
  }
}
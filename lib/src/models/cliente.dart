class Cliente {
  String email;
  Nombre nombre;
  String clienteID;
  Direccion direccion;
  int telefono;
  bool estaAutenticado;

  /// ADMIN: Mapea el cliente desde Firebase
  Cliente.fromMap(Map<String, dynamic> data, this.clienteID) {
    email = data['email'] as String;
    telefono = data['telefono'] as int;
    estaAutenticado = data['estaAutenticado'] as bool;
    nombre = Nombre.fromMap(data['nombre'] as Map);
    direccion = Direccion.fromMap(data['direccion'] as Map);
  }

  Cliente.fromPedidos(Map<String, dynamic> data) {
    clienteID = data['cliente']['clienteID'] as String;
    nombre = Nombre.fromMap(data['cliente']['nombre']);
  }

  Cliente.fromAddressEditing(Cliente cliente, Map<String, dynamic> address) {
    clienteID = cliente.clienteID;
    telefono = cliente.telefono;
    email = cliente.email;
    estaAutenticado = cliente.estaAutenticado;
    nombre = Nombre.fromAddressEditing(cliente.nombre);
    direccion = Direccion.fromAddressEditing(address);
  }
}

class Nombre {
  String nombre;
  String apellido;

  Nombre.fromMap(Map<String, dynamic> data) {
    nombre = data['nombre'] as String;
    apellido = data['apellido'] as String;
  }

  Nombre.fromAddressEditing(Nombre nom) {
    nombre = nom.nombre;
    apellido = nom.apellido;
  }
}

class Direccion {
  String aclaracion;
  String calle;
  String ciudad;
  int codigoPostal;
  int numero;
  String piso;
  String depto;
  String provincia;

  Direccion.fromMap(Map<String, dynamic> data) {
    aclaracion = data['aclaracion'] as String;
    calle = data['calle'] as String;
    ciudad = data['ciudad'] as String;
    codigoPostal = data['codigoPostal'].toInt() as int;
    numero = data['numero'].toInt() as int;
    piso = data['piso'] as String;
    depto = data['departamento'] as String;
    provincia = data['provincia'] as String;
  }

  Direccion.fromAddressEditing(Map<String, dynamic> data) {
    aclaracion = data['aclaracion'] as String;
    calle = data['calle'] as String;
    ciudad = data['ciudad'] as String;
    codigoPostal = int.parse(data['codigoPostal']);
    numero = int.parse(data['numero']);
    piso = data['piso'] as String;
    depto = data['departamento'] as String;
    provincia = data['provincia'] as String;
  }
}

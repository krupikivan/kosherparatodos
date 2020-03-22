import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/cliente_notifier.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class AdminProvider{

final Repository _repository = FirestoreProvider();

getClientes(ClienteNotifier clienteNotifier) async{
  List<Cliente> _clienteList = [];
  await _repository.getClientes().then((snapshot){
    snapshot.documents.forEach((documents){
      Cliente cliente = Cliente.fromMap(documents.data);
      _clienteList.add(cliente);
    });
    clienteNotifier.clienteList = _clienteList;
  });
}

}

final adminProvider = AdminProvider();
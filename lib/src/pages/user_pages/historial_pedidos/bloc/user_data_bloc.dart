import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
import 'package:kosherparatodos/src/providers/connectivity.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class ClienteDataBloc {
  final Repository _repository = FirestoreProvider();
  Cliente _clienteInfo;
  final _conex = ConnectivityProvider.getInstance();
  List<Pedido> listPedido = [];
  // Pedido pedidoSelected = Pedido();

//---------------------------------Maneja los datos del cliente
  final _clienteData = BehaviorSubject<Cliente>();
  Observable<Cliente> get getCliente => _clienteData.stream;
  Function(Cliente) get setCliente => _clienteData.sink.add;

//---------------------------------Maneja los pedidos del cliente
  final _pedidosList = BehaviorSubject<List<Pedido>>();
  Observable<List<Pedido>> get getListPedidos => _pedidosList.stream;
  Function(List<Pedido>) get addToPedidosList => _pedidosList.sink.add;

//  Retorna los datos del cliente logueado
  Cliente getClienteLogeado() {
    return _clienteInfo;
  }

//  Trae los datos del cliente logueado desde Firebase
  void getUserDataFromFirebase(String uid) {
    _repository.getUserData(uid).listen((docUser) {
      final Cliente cliente = Cliente.fromMap(docUser.data, docUser.documentID);
      _clienteInfo = cliente;
      setCliente(cliente);
      getPedidos(uid);
    });
  }

//  Trae los pedidos del cliente logueado con su detalle
  Future getPedidos(String uid) {
    return _repository.getPedidosCliente(uid).then((value) {
      listPedido.clear();
      for (int i = 0; i < value.documents.length; i++) {
        final Pedido pedido = Pedido.fromFirebase(
            value.documents[i].data, value.documents[i].documentID);
        listPedido.add(pedido);
      }
      addToPedidosList(listPedido);
    });
  }

  void updatePedidoFromBloc(String pedId) async {
    List<Pedido> _listPe = [];
    _listPe = await getListPedidos.firstWhere((event) => true);
    _listPe.removeWhere((element) => element.pedidoID == pedId);
    addToPedidosList(_listPe);
  }

  Future userEdit(Cliente cliente) async {
    if (_conex.hasConnection) {
      await _repository
          .addUserAddress(cliente)
          .then((value) => true, onError: (onError) => _handlingError('Error'));
    } else {
      throw 'No hay conexion';
    }
  }

  void updateEnvio(String id, bool envio) {
    _pedidosList.listen((element) => element.forEach((ped) {
          if (ped.pedidoID == id) {
            ped.envio = envio;
          }
        }));
  }

//  Se comunica con el bloc del pedido vigente y se carga en el carrito
  // void editarPedido(Pedido pedidoSelected) {
  //   blocPedidoVigente.agregarPedidoParaEditar(pedidoSelected);
  // }

// Eliminamos el pedido desde el detalle del historial
  Future eliminarPedido(Pedido pedidoSelected) async {
    await _repository
        .eliminarPedido(pedidoSelected)
        .then((value) => true, onError: (onError) => _handlingError('Error'));
  }

  _handlingError(String msg) {
    throw Exception(msg);
  }

  void dispose() async {
    await _clienteData.drain();
    _clienteData.close();
    await _pedidosList.drain();
    _pedidosList.close();
  }
}

final ClienteDataBloc blocUserData = ClienteDataBloc();

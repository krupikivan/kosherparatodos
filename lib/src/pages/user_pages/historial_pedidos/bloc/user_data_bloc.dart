import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class ClienteDataBloc {
  final Repository _repository = FirestoreProvider();
  Cliente _clienteInfo;
  List<Pedido> listPedido = List();
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
  void getPedidos(String uid) {
    _repository.getPedidosCliente(uid).then((value) {
      listPedido.clear();
      for (int i = 0; i < value.documents.length; i++) {
        final Pedido pedido = Pedido.fromFirebase(
            value.documents[i].data, value.documents[i].documentID);
        listPedido.add(pedido);
      }
      addToPedidosList(listPedido);
    });
  }

//  Se comunica con el bloc del pedido vigente y se carga en el carrito
  void editarPedido(Pedido pedidoSelected) {
    blocPedidoVigente.agregarPedidoParaEditar(pedidoSelected);
  }

// Eliminamos el pedido desde el detalle del historial
  void eliminarPedido(Pedido pedidoSelected) {
    _repository
        .eliminarPedido(pedidoSelected.pedidoID)
        .then((value) => getPedidos(_clienteInfo.clienteID));
  }

  void dispose() async {
    await _clienteData.drain();
    _clienteData.close();
    await _pedidosList.drain();
    _pedidosList.close();
  }
}

final ClienteDataBloc blocUserData = ClienteDataBloc();

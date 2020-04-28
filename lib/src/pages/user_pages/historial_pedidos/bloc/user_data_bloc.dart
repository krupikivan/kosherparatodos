import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/user_data.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class UserDataBloc {

  final Repository _repository = FirestoreProvider();
  String _userId;
  List<Pedido> listPedido = List();
  Pedido pedidoSelected = Pedido();


  final _docUserData = BehaviorSubject<UserData>();
  Observable<UserData> get getUserData => _docUserData.stream;
  Function(UserData) get addUserData => _docUserData.sink.add;

  final _pedidosList = BehaviorSubject<List<Pedido>>();
  Observable<List<Pedido>> get getListPedidos => _pedidosList.stream;
  Function(List<Pedido>) get addToPedidosList => _pedidosList.sink.add;

  final _pedidoSelected = BehaviorSubject<Pedido>();
  Observable<Pedido> get getPedidoSelected => _pedidoSelected.stream;
  Function(Pedido) get addSelectPedido => _pedidoSelected.sink.add;

  getUserId(){
    return _userId;
  }

  getUserDataFromFirebase(uid) {
    //Get from firebase
    _repository.getUserData(uid).listen((docUser) {
      UserData userData = new UserData();
      userData.email = docUser.data['email'];
      userData.id = uid;
      _userId = uid;
      userData.name = docUser.data['name'];
      addUserData(userData);
      _getPedidos(uid);
    });
  }

  _getPedidos(String uid) {
    _repository.getPedido(uid).onData((value) {
      listPedido.clear();
      for (int i = 0; i < value.documents.length; i++) {
        Pedido pedido = new Pedido();
        pedido.idPedido = value.documents[i].documentID;
        pedido.fecha = value.documents[i].data['fecha'];
        pedido.total = value.documents[i].data['total'] == null ? 0 : value.documents[i].data['total'].toDouble();
        pedido.pagado = value.documents[i].data['pagado'] == true
            ? Pagado.PAGADO
            : Pagado.NOPAGADO;
        pedido.estado = Pedido().getEstado(value.documents[i].data['estado']);
        listPedido.add(pedido);
      }
      addToPedidosList(listPedido);
    });
  }

  getDetallePedido(String uid) {
    List<DetallePedido> listDetallePedido = List();
    _repository.getDetallePedido(uid).then((queryDetalle) {
      for (int i = 0; i < queryDetalle.documents.length; i++) {
        DocumentSnapshot doc = queryDetalle.documents[i];
        DetallePedido detalle = DetallePedido.fromFirebase(doc.data, doc.documentID);
        listDetallePedido.add(detalle);
      }
      pedidoSelected = listPedido.firstWhere((element) => element.idPedido == uid);
      pedidoSelected.detallePedido = listDetallePedido;
      pedidoSelected.idPedido = uid;
      addSelectPedido(pedidoSelected);
    });
  }

  addPedidoForEdit(){
    blocPedidoVigente.addingPedidoForEdit(pedidoSelected);
  }

  deletePedido(){
      _repository.deletePedido(pedidoSelected.idPedido);
  }

  void dispose() async {
    await _docUserData.drain();
    _docUserData.close();
    await _pedidosList.drain();
    _pedidosList.close();
      await _pedidoSelected.drain();
    _pedidoSelected.close();
  }
}

final blocUserData = UserDataBloc();

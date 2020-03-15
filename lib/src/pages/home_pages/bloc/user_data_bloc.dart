import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/user_data.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class UserDataBloc {
  final _repository = Repository();

  final _docUserData = BehaviorSubject<UserData>();
  Observable<UserData> get getUserData => _docUserData.stream;
  Function(UserData) get addUserData => _docUserData.sink.add;

  final _docPedidos = BehaviorSubject<List<Pedido>>();
  Observable<List<Pedido>> get getPedidos => _docPedidos.stream;
  Function(List<Pedido>) get addPedidos => _docPedidos.sink.add;

  final _docDetallePedido = BehaviorSubject<List<DetallePedido>>();
  Observable<List<DetallePedido>> get getDetalle => _docDetallePedido.stream;
  Function(List<DetallePedido>) get addDetalle => _docDetallePedido.sink.add;

  getUserDataFromFirebase(uid) {
    //Get from firebase
    _repository.getUserData(uid).listen((docUser) {
      UserData userData = new UserData();
      userData.email = docUser.data['email'];
      userData.id = uid;
      userData.name = docUser.data['name'];
      addUserData(userData);
      _getPedidos(uid);
    });
  }

  _getPedidos(String uid) {
    List<Pedido> listPedido = List();
    _repository.getPedido(uid).then((value) {
      for (int i = 0; i < value.documents.length; i++) {
        Pedido pedido = new Pedido();
        pedido.idPedido = value.documents[i].documentID;
        pedido.cliente = value.documents[i].data['cliente'];
        pedido.fecha = value.documents[i].data['fecha'];
        pedido.total = value.documents[i].data['total'].toDouble();
        pedido.pagado = value.documents[i].data['pagado'] == true
            ? Estado.PAGADO
            : Estado.NOPAGADO;
        pedido.estado = value.documents[i].data['estado'];
        listPedido.add(pedido);
      }
      addPedidos(listPedido);
    });
  }

  getDetallePedido(String uid) {
    List<DetallePedido> listDetallePedido = List();
    _repository.getDetallePedido(uid).then((queryDetalle) {
      for (int i = 0; i < queryDetalle.documents.length; i++) {
        DocumentSnapshot doc = queryDetalle.documents[i];
        DetallePedido detalle = new DetallePedido();
        detalle.name = doc.documentID;
        detalle.unidad = doc.data['unidadMedida'];
        detalle.cantidad = doc.data['cantidad'];
        listDetallePedido.add(detalle);
      }
      addDetalle(listDetallePedido);
    });
  }

  void dispose() async {
    await _docUserData.drain();
    _docUserData.close();
    await _docPedidos.drain();
    _docPedidos.close();
      await _docDetallePedido.drain();
    _docDetallePedido.close();
  }
}

final blocUserData = UserDataBloc();

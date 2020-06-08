import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final Repository _repository = FirestoreProvider();

  final _productosList = PublishSubject<List<Producto>>();

  //Stream que maneja los productos de Firebase para agregar al pedido
  Observable<List<Producto>> get getProductosVigentes => _productosList.stream;
  Function(List<Producto>) get addProductosVigentes => _productosList.sink.add;

  List<Producto> list = [];
  List<ItemPedido> listOpciones = [];

//  Trae los productos habilitados para el cliente
  getProductosHabilitados() {
    list.clear();
    _repository.getProductosHabilitados().then((doc) {
      for (int i = 0; i < doc.documents.length; i++) {
        Producto producto = Producto.fromProductosCollection(
            doc.documents[i].data, doc.documents[i].documentID);
        list.add(producto);
      }
      addProductosVigentes(list);
    });
  }

  void dispose() async {
    await _productosList.drain();
    _productosList.close();
  }
}

final ProductosBloc blocProductos = ProductosBloc();

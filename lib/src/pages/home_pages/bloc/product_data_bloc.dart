import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/models/producto_concreto.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class ProductDataBloc {
  final Repository _repository = FirestoreProvider();

  final _docProductList = PublishSubject<List<Producto>>();
  Observable<List<Producto>> get getProducts => _docProductList.stream;
  Function(List<Producto>) get addProducts => _docProductList.sink.add;

  List<Producto> list = List();
  List<ProductoConcreto> listConcreto = List();

//Me trae los productos de Firebase
  getProductList() {
    list.clear();
    _repository.getProductList().onData((doc) {
      for (int i = 0; i < doc.documents.length; i++) {
        Producto producto = new Producto();
        producto.nombre = doc.documents[i].data['nombre'];
        producto.descripcion = doc.documents[i].data['descripcion'];
        producto.idProducto = doc.documents[i].documentID;
        producto.habilitado = doc.documents[i].data['habilitado'];
        producto.ultimaActualizacion =
            doc.documents[i].data['ultimaActualizacion'];
        list.add(producto);
      }
      addProducts(list);
    });
  }

//Me trae los productos concretos de Firebase
  getProductoConcretoList(String productoID) {
    listConcreto.clear();
    _repository.getProductoConcreto(productoID).onData((doc) {
      for (int i = 0; i < doc.documents.length; i++) {
        ProductoConcreto productoConcreto = new ProductoConcreto();
        productoConcreto.precioTotal =
            doc.documents[i].data['precioTotal'].toDouble();
        productoConcreto.cantidad = doc.documents[i].data['cantidad'].toInt();
        productoConcreto.idConcreto = doc.documents[i].documentID;
        productoConcreto.descripcion = doc.documents[i].data['descripcion'];
        listConcreto.add(productoConcreto);
      }
      Producto productFound =
          list.firstWhere((prod) => prod.idProducto == productoID);
      productFound.concreto = listConcreto;
      addProducts(list);
    });
  }

  void dispose() async {
    await _docProductList.drain();
    _docProductList.close();
  }
}

final blocProductData = ProductDataBloc();

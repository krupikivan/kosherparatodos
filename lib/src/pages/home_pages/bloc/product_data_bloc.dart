import 'package:kosherparatodos/src/models/product.dart';
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
    _repository.getProductList().then((doc) {
      for (int i = 0; i < doc.documents.length; i++) {
        Producto producto = new Producto();
        producto.nombre = doc.documents[i].data['nombre'];
        producto.descripcion = doc.documents[i].data['descripcion'];
        producto.bulto = doc.documents[i].data['bulto'];
        producto.idProducto = doc.documents[i].documentID;
        producto.habilitado = doc.documents[i].data['habilitado'];
        producto.ultimaActualizacion =
        doc.documents[i].data['ultimaActualizacion'];
        producto.imagen = doc.documents[i].data['imagen'];
        list.add(producto);
      }
      addProducts(list);
    });
  }

//Me trae los productos concretos de Firebase
  getProductoConcretoList(String productoID) async{
      listConcreto.clear();
      await _repository.getProductoConcreto(productoID).then((doc) {
        for (int i = 0; i < doc.documents.length; i++) {
          ProductoConcreto productoConcreto = new ProductoConcreto();
          productoConcreto.precioTotal = doc.documents[i].data['precioTotal'].toDouble();
          productoConcreto.cantidad = doc.documents[i].data['cantidad'].toDouble();
          productoConcreto.precioUnitario = doc.documents[i].data['precioUnitario'].toDouble();
          productoConcreto.unidadMedida = doc.documents[i].data['unidadMedida'];
          productoConcreto.id = doc.documents[i].documentID;
          productoConcreto.descripcion = doc.documents[i].data['descripcion'];
          listConcreto.add(productoConcreto);
        }
      });
    Producto productFound =
        list.firstWhere((prod) => prod.idProducto == productoID);
    productFound.concreto = listConcreto;
    addProducts(list);
  }

  void dispose() async {
    await _docProductList.drain();
    _docProductList.close();
  }
}

final blocProductData = ProductDataBloc();

import 'package:kosherparatodos/src/models/product.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class ProductDataBloc {
  final _repository = Repository();

  final _docProductList = BehaviorSubject<List<Producto>>();
  Observable<List<Producto>> get getProducts => _docProductList.stream;
  Function(List<Producto>) get addProducts => _docProductList.sink.add;

  List<Producto> list = List();


  getProductList() {
    list.clear();
    _repository.getProductList().then((doc) {
      for(int i=0; i<doc.documents.length; i++){
          Producto producto = new Producto();
          producto.precioUnitario = doc.documents[i].data['precioUnitario'].toDouble();
          producto.nombre = doc.documents[i].data['nombre'];
          producto.bulto = doc.documents[i].data['bulto'];
          producto.idProducto = doc.documents[i].documentID;
          producto.ultimaActualizacion = doc.documents[i].data['ultimaActualizacion'];
          producto.unidadMedida = doc.documents[i].data['unidadMedida'];
          producto.image = doc.documents[i].data['image'];
          producto.descripcion = doc.documents[i].data['descripcion'];
          producto.opcionCantidad = doc.documents[i].data['opcionCantidad'];
          producto.tipo = doc.documents[i].data['tipo'];
          list.add(producto);
      }
      addProducts(list);
    });
  }

  void dispose() async {
    await _docProductList.drain();
    _docProductList.close();
  }
}

final blocProductData = ProductDataBloc();

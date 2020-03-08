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
          producto.cantidad = doc.documents[i].data['cantidad'];
          producto.name = doc.documents[i].data['name'];
          producto.costo = doc.documents[i].data['costo'];
          producto.idProducto = doc.documents[i].documentID;
          producto.ultimaActualizacion = doc.documents[i].data['ultimaActualizacion'];
          producto.unidadMedida = doc.documents[i].data['unidadMedida'];
          producto.image = doc.documents[i].data['image'];
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

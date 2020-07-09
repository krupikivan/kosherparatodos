import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final Repository _repository = FirestoreProvider();

  final _productosList = PublishSubject<List<Producto>>();
  final _categoriaList = PublishSubject<List<Categoria>>();
  final _categoriaSelected = PublishSubject<Categoria>();

  //Stream que maneja los productos de Firebase para agregar al pedido
  Observable<List<Producto>> get getProductosVigentes => _productosList.stream;
  Function(List<Producto>) get addProductosVigentes => _productosList.sink.add;

  //Stream que maneja las categorias de Firebase para agregar al pedido
  Observable<List<Categoria>> get getCategorias => _categoriaList.stream;
  Function(List<Categoria>) get addCategorias => _categoriaList.sink.add;

  //Stream que maneja la categoria seleccionada
  Observable<Categoria> get getCategoriaSelected => _categoriaSelected.stream;
  Function(Categoria) get addCategoriaSelected => _categoriaSelected.sink.add;

  List<Producto> _prodList = [];
  List<Categoria> _cateList = [];

//  Trae los productos habilitados para el cliente
  void getProductosHabilitados() {
    _prodList.clear();
    _repository.getProductosHabilitados().then((doc) {
      for (int i = 0; i < doc.documents.length; i++) {
        final Producto producto = Producto.fromProductosCollection(
            doc.documents[i].data, doc.documents[i].documentID);
        _prodList.add(producto);
      }
      addProductosVigentes(_prodList);
    });
  }

//  Trae las categorias habilitados para el cliente
  void getAllCategorias() {
    _cateList.clear();
    _repository.getAllCategorias().then((doc) {
      for (int i = 0; i < doc.documents.length; i++) {
        final Categoria categoria = Categoria.fromFirebase(
            doc.documents[i].data, doc.documents[i].documentID);
        _cateList.add(categoria);
      }
      addCategorias(_cateList);
    });
  }

  void dispose() async {
    await _productosList.drain();
    _productosList.close();
  }
}

final ProductosBloc blocProductos = ProductosBloc();

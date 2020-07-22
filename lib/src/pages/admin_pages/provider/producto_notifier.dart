import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/providers/connectivity.dart';
import 'package:kosherparatodos/src/repository/firebase_storage.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class ProductoNotifier with ChangeNotifier {
  final Repository _repository = FirestoreProvider();
  final _conex = ConnectivityProvider.getInstance();

  void updateAllData() {
    if (_conex.hasConnection) {
      _repository.updateAllData(_productoActual);
    } else {
      throw 'No hay conexion';
    }
  }

  int getProductosLength() {
    return _productoList.length;
  }

  double getTotal(int cantidad, double precio) {
    return cantidad * precio;
  }

  void addNewProducto(PickedFile file) async {
    _repository.addNewProducto(_productoNuevo).whenComplete(() async {
      if (file != null) {
        final FireStorageService storage = FireStorageService.instance();
        await storage
            .uploadImage(file, _productoNuevo.codigo)
            .then((value) => null);
        _clearProductoNuevo();
      } else {
        _clearProductoNuevo();
      }
    }).catchError((onError) => print('Error'));
  }

  void _clearProductoNuevo() {
    _categoriaString.clear();
    _productoNuevo = null;
  }

  //-------------Se ejecuta cuando selecciono una categoria hijo para traer los productos
  void getProductos(String categoriaHijoId) {
    _productoList.clear();
    final List<Producto> _list = [];
    _repository.getProductosFromHijoSelected(categoriaHijoId).then((listProd) {
      _list.clear();
      listProd.documents.forEach((producto) {
        final Producto _producto = Producto.fromProductosCollection(
            producto.data, producto.documentID);
        _list.add(_producto);
        _productoList = _list;
        notifyListeners();
      });
    });
  }

  void addImage(int index, String data) {
    print('Se agrego');
    _productoList[index].imagen = data;
    // notifyListeners();
  }

  Future changeImageName(String data) async {
    await _repository.changeImageUrl(_productoActual);
    // _productoList.firstWhere((element) => element.productoID == _productoActual.productoID).imagen = data;
    _productoList.forEach((element) {
      if (element.productoID == _productoActual.productoID) {
        element.imagen = data;
        return;
      }
    });
    // _productoActual.imagen = _productoActual.codigo;
    notifyListeners();
  }

  // getProductosFromHijoSelected(String idHijo) {
  //   List<Producto> _list = [];
  //   _repository.getProductosFromHijoSelected(idHijo).then((listProd) {
  //     _list.clear();
  //     listProd.documents.forEach((producto) {
  //       Producto _producto =
  //           Producto.fromGetProductos(producto.data, producto.documentID);
  //       _list.add(_producto);
  //       _productoList = _list;
  //       notifyListeners();
  //     });

  //   });
  // }

  void setHabilitado() {
    final bool hab = !_productoActual.habilitado;
    try {
      _repository.setHabilitado(_productoActual.productoID, habilitado: hab);
      _productoActual.habilitado = hab;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void setData(String tipo, String name) {
    switch (tipo) {
      case 'C':
        _productoActual.codigo = name;
        notifyListeners();
        break;
      case 'D':
        _productoActual.descripcion = name;
        notifyListeners();
        break;
      case 'M':
        _productoActual.marca = name;
        notifyListeners();
        break;
      case 'UM':
        _productoActual.unidadMedida = name;
        notifyListeners();
        break;
      case 'S':
        _productoActual.stock = int.parse(name.toString());
        notifyListeners();
        break;
      case 'P':
        _productoActual.precio = double.parse(name.toString());
        notifyListeners();
        break;
    }
  }

  void addToCategoriaString(String id, bool val) {
    val ? _categoriaString.add(id) : _categoriaString.remove(id);
  }

  void creatingProducto(Producto nuevo) {
    _productoNuevo = nuevo;
    _productoNuevo.categorias = _categoriaString;
    // notifyListeners();
  }

  void deleteProducto(String idProducto) {
    try {
      _repository.deleteProducto(idProducto);
      _productoList.retainWhere((element) => element.productoID == idProducto);
      // getProductos();
    } catch (e) {
      print(e);
    }
  }

//---------------------------Todos los productos
  List<Producto> _productoList = [];
  UnmodifiableListView<Producto> get productoList =>
      UnmodifiableListView(_productoList);
  set productoList(List<Producto> productoList) {
    _productoList = productoList;
    notifyListeners();
  }

  void clearProductoList() {
    _productoList.clear();
    notifyListeners();
  }

//---------------------------Producto que estoy viendo
  Producto _productoActual;
  Producto get productoActual => _productoActual;
  set productoActual(Producto productoActual) {
    _productoActual = productoActual;
    notifyListeners();
  }

//---------------------------Producto que estoy creando
  Producto _productoNuevo;
  Producto get productoNuevo => _productoNuevo;
  set productoNuevo(Producto productoNuevo) {
    _productoNuevo = productoNuevo;
    notifyListeners();
  }

//---------------------------Categorias string para el producto nuevo
  List<String> _categoriaString = [];
  List<String> get categoriaString => _categoriaString;
  set categoriaString(List<String> categoriaString) {
    _categoriaString = categoriaString;
    notifyListeners();
  }

// //---------------------------Los Productos de la categoria hijo seleccionada
//   List<Producto> _productoCategoriaList = [];
//   UnmodifiableListView<Producto> get productoCategoriaList =>
//       UnmodifiableListView(_productoCategoriaList);
//   set productoCategoriaList(List<Producto> prodList) {
//     _productoCategoriaList = prodList;
//     notifyListeners();
//   }

// //---------------------------Producto seleccionada luego de listar los productos de categoria hijo
//   Producto _productoCategoriaActual;
//   Producto get productoCategoriaActual => _productoCategoriaActual;
//   set productoCategoriaActual(Producto productoActual) {
//     _productoCategoriaActual = productoActual;
//     notifyListeners();
//   }

}

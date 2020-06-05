import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class ProductoNotifier with ChangeNotifier {
  final Repository _repository = FirestoreProvider();



  // ProductoNotifier.init() {
  //   getProductos();
  // }

  updateAllData(){
    _repository.updateAllData(_productoActual);
  }
  
  getProductosLength(){
    return _productoList.length;
  }

  getTotal(cantidad, precio){
    return cantidad * precio;
  }

  addNewProducto() {
    _repository.addNewProducto(_productoNuevo).whenComplete(() => _clearProductoNuevo());
  }
  _clearProductoNuevo(){
    _categoriaString.clear();
    _productoNuevo = null;
  }

  //-------------Se ejecuta cuando selecciono una categoria hijo para traer los productos
  getProductos(String categoriaHijoId) {
    _productoList.clear();
    List<Producto> _list = [];
    _repository.getProductosFromHijoSelected(categoriaHijoId).then((listProd) {
      _list.clear();
      listProd.documents.forEach((producto) {
        Producto _producto =
            Producto.fromGetProductos(producto.data, producto.documentID);
        _list.add(_producto);
        _productoList = _list;
        notifyListeners();
      });

    });
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

  setHabilitado(){
    bool hab = _productoActual.habilitado == true ? false : true;
    try{
    _repository.setHabilitado(_productoActual.productoID, hab);
    _productoActual.habilitado = hab;
    notifyListeners();
    }catch(e){}
  }

  setData(tipo, name){
    switch(tipo){
      case 'C': _productoActual.codigo = name;
                notifyListeners();
        break;
      case 'D': _productoActual.descripcion = name;
                notifyListeners();
        break;
      case 'UM': _productoActual.unidadMedida = name;
                notifyListeners();
        break;
      case 'S': _productoActual.stock = int.parse(name.toString());
                notifyListeners();
        break;
      case 'P': _productoActual.precio = double.parse(name.toString());
                // _productoActual.opciones.forEach((element) {
                //   element.precioTotal = element.cantidad * _productoActual.precio;
                // });
                notifyListeners();
        break;
    }
  }

  // setItemData(String descripcion, var cantPrec, int index){
  //  for(var i=0;i<_productoActual.opciones.length; i++){
  //    if(_productoActual.opciones[i] == _productoActual.opciones[index]){
  //      _productoActual.opciones[i].descripcion = descripcion;
  //      _productoActual.precio == 0 ? _productoActual.opciones[i].precioTotal = cantPrec.toDouble() : _productoActual.opciones[i].cantidad = cantPrec.toInt();
  //      _productoActual.precio == 0 ? _productoActual.opciones[i].precioTotal = cantPrec.toDouble() : _productoActual.opciones[i].precioTotal = cantPrec * _productoActual.precio;
  //    }
  //  }
  //  notifyListeners();
  // }

  // getDetalleProducto() {
  //   List<Opcion> _list = [];
  //   _repository
  //       .getProductoConcreto(_productoActual.idProducto)
  //       .onData((concretoList) {
  //         _list.clear();
  //     concretoList.documents.forEach((concreto) {
  //       ProductoConcreto productoConcreto =
  //           ProductoConcreto.fromMap(concreto.data, concreto.documentID);
  //       _list.add(productoConcreto);
  //       _productoActual.concreto = _list;
  //       notifyListeners();
  //     });
  //   });
  // }

  creatingProducto(Producto nuevo){
    _productoNuevo = nuevo;
    _productoNuevo.categorias = _categoriaString;
    // notifyListeners();
  }

  deleteProducto(String idProducto) {
    try {
      _repository.deleteProducto(idProducto);
      _productoList.retainWhere((element) => element.productoID == idProducto);
      // getProductos();
    } catch (e) {}
  }

//---------------------------Todos los productos
  List<Producto> _productoList = [];
  UnmodifiableListView<Producto> get productoList =>
      UnmodifiableListView(_productoList);
  set productoList(List<Producto> productoList) {
    _productoList = productoList;
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

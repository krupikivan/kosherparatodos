import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class ProductoNotifier with ChangeNotifier {
  final Repository _repository = FirestoreProvider();

  List<Producto> _productoList = [];
  Producto _productoActual;
  UnmodifiableListView<Producto> get productoList =>
      UnmodifiableListView(_productoList);

  ProductoNotifier.init() {
    getProductos();
  }

  updateAllData(){
    _repository.updateAllData(_productoActual);
  }
  
  getProductosLength(){
    return _productoList.length;
  }

  getTotal(cantidad, precio){
    return cantidad * precio;
  }

  // addNewProducto(String nombre, String descripcion, double precio,
      // bool habilitado, List<Opcion> list) {
    // Producto _newProd = Producto.newProducto(nombre, descripcion, precio, habilitado, list);
    // _repository.addNewProducto(_newProd);
  // }

  getProductos() {
    List<Producto> _list = [];
    _repository.getProductList().onData((listProd) {
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

  setHabilitado(){
    bool hab = _productoActual.habilitado == true ? false : true;
    try{
    _repository.setHabilitado(_productoActual.productoID, hab);
    _productoActual.habilitado = hab;
    getProductos();
    }catch(e){}
  }

  setData(tipo, name){
    switch(tipo){
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

  deleteProducto(String idProducto) {
    try {
      _repository.deleteProducto(idProducto);
      _productoList.retainWhere((element) => element.productoID == idProducto);
      getProductos();
    } catch (e) {}
  }

  Producto get productoActual => _productoActual;

  set productoList(List<Producto> productoList) {
    _productoList = productoList;
    notifyListeners();
  }

  set productoActual(Producto productoActual) {
    _productoActual = productoActual;
    notifyListeners();
  }
}

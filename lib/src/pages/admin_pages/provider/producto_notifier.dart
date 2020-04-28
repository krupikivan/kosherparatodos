import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/models/producto_concreto.dart';
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

  addNewProducto(String nombre, String descripcion, double precio,
      bool habilitado, List<ProductoConcreto> list) {
    Producto _newProd =
        Producto.fromNewProd(nombre, descripcion, precio, habilitado, list);
    _repository.addNewProducto(_newProd);
  }

  getProductos() {
    List<Producto> _list = [];
    _repository.getProductList().onData((listProd) {
      _list.clear();
      listProd.documents.forEach((producto) {
        Producto _producto =
            Producto.fromMap(producto.data, producto.documentID);
        _list.add(_producto);
        _productoList = _list;
        notifyListeners();
      });
    });
  }

  setHabilitado(){
    bool hab = _productoActual.habilitado == true ? false : true;
    try{
    _repository.setHabilitado(_productoActual.idProducto, hab);
    _productoActual.habilitado = hab;
    getProductos();
    }catch(e){}
  }

  setData(tipo, name){
    switch(tipo){
      case 'N': _productoActual.nombre = name;
                notifyListeners();
        break;
      case 'D': _productoActual.descripcion = name;
                notifyListeners();
        break;
      case 'P': _productoActual.precioUnitario = double.parse(name.toString());
                _productoActual.concreto.forEach((element) {
                  element.precioTotal = element.cantidad * _productoActual.precioUnitario;
                });
                notifyListeners();
        break;
    }
  }

  setItemData(String descripcion, var cantPrec, int index){
   for(var i=0;i<_productoActual.concreto.length; i++){
     if(_productoActual.concreto[i] == _productoActual.concreto[index]){
       _productoActual.concreto[i].descripcion = descripcion;
       _productoActual.precioUnitario == 0 ? _productoActual.concreto[i].precioTotal = cantPrec.toDouble() : _productoActual.concreto[i].cantidad = cantPrec.toInt();
       _productoActual.precioUnitario == 0 ? _productoActual.concreto[i].precioTotal = cantPrec.toDouble() : _productoActual.concreto[i].precioTotal = cantPrec * _productoActual.precioUnitario;
     }
   }
   notifyListeners();
  }

  getDetalleProducto() {
    List<ProductoConcreto> _list = [];
    _repository
        .getProductoConcreto(_productoActual.idProducto)
        .onData((concretoList) {
          _list.clear();
      concretoList.documents.forEach((concreto) {
        ProductoConcreto productoConcreto =
            ProductoConcreto.fromMap(concreto.data, concreto.documentID);
        _list.add(productoConcreto);
        _productoActual.concreto = _list;
        notifyListeners();
      });
    });
  }

  deleteProducto(String idProducto) {
    try {
      _repository.deleteProducto(idProducto);
      _productoList.retainWhere((element) => element.idProducto == idProducto);
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

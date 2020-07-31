import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/Widget/show_toast.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/widgets/custom_icon.dart';
import 'package:kosherparatodos/src/pages/admin_pages/widgets/export.dart';
import 'package:kosherparatodos/src/repository/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductoDetailPage extends StatelessWidget {
  TextEditingController _codigoController;
  TextEditingController _descripcionController;
  TextEditingController _marcaController;
  TextEditingController _stockController;
  TextEditingController _precioController;
  TextEditingController _umController;
  File _image;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<ProductoNotifier>(context);
    _fillControllerData(prod.productoActual);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  color: Colors.black,
                  text: 'Detalle del producto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                Column(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: prod.productoActual.imagen == ""
                            ? AssetImage('assets/images/logo.png')
                            : NetworkImage(prod.productoActual.imagen),
                        radius: 40,
                      ),
                      onTap: () => choose(context, prod),
                    ),
                    Text("Cargar imagen")
                  ],
                ),
              ],
            ),
          ),
          InputDataField(
              controller: _descripcionController,
              isNum: false,
              tipo: 'D',
              description: "Descripcion"),
          InputDataField(
              tipo: 'M',
              controller: _marcaController,
              isNum: false,
              description: "Marca"),
          InputDataField(
            tipo: 'C',
            controller: _codigoController,
            isNum: false,
            description: 'Codigo',
          ),
          InputDataField(
            tipo: 'UM',
            controller: _umController,
            isNum: false,
            description: 'Unidad de medida',
          ),
          InputDataField(
            tipo: 'S',
            controller: _stockController,
            isNum: true,
            description: 'Stock',
          ),
          InputDataField(
              tipo: 'P',
              controller: _precioController,
              isNum: true,
              description: 'Precio unitario'),
          EstadoHabilitado(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () => _updateAllData(context),
        label: const Text('Guardar'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void choose(BuildContext context, ProductoNotifier prod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: TitleText(
          color: Colors.black,
          text: 'Cargar foto',
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        content: Container(
          height: 100,
          width: 100,
          child: Row(
            children: [
              FlatButton(
                  onPressed: () => null, //getImage(ImageSource.gallery, prod),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('Abrir galeria'),
                      CustomIcon(icon: Icons.image, context: context),
                    ],
                  )),
              // FlatButton(
              //     onPressed: () => null, // getImage(ImageSource.camera, prod),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: <Widget>[
              //         Text('Sacar foto'),
              //         CustomIcon(icon: Icons.camera, context: context),
              //       ],
              //     ))
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Volver",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future getImage(ImageSource source, ProductoNotifier prod) async {
    final FireStorageService storage = FireStorageService.instance();
    await _getPermission();
    if (_permissionStatus == PermissionStatus.granted) {
      final pickedFile = await ImagePicker.pickImage(source: source);
      if (pickedFile != null) {
        _image = pickedFile;
        await storage.uploadImage(_image, prod.productoActual.codigo);
        final img = await storage.getImage(prod.productoActual.codigo);
        await prod.changeImageName(img);
      }
    } else {
      print('No tiene permisos');
    }
  }

  // get permissions
  Future<PermissionStatus> _getPermission() async {
    final Permission _perms = Permission.camera;
    _permissionStatus = await _perms.request();
    if (_permissionStatus != PermissionStatus.granted &&
        _permissionStatus != PermissionStatus.denied) {
      return _permissionStatus;
    } else {
      print(_permissionStatus);
      return _permissionStatus;
    }
  }

  void _updateAllData(BuildContext context) {
    try {
      Provider.of<ProductoNotifier>(context, listen: false).updateAllData();
      Navigator.pop(context);
      ShowToast().show('Listo!', 5);
    } catch (e) {
      ShowToast().show('$e', 5);
    }
  }

  void _fillControllerData(Producto producto) {
    _codigoController = TextEditingController(text: producto.codigo);
    _descripcionController = TextEditingController(text: producto.descripcion);
    _marcaController = TextEditingController(text: producto.marca);
    _umController = TextEditingController(text: producto.unidadMedida);
    _stockController = TextEditingController(text: producto.stock.toString());
    _precioController = TextEditingController(text: producto.precio.toString());
  }
}

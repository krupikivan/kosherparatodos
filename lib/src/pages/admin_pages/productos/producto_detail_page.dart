import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/Widget/show_toast.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/widgets/export.dart';
import 'package:kosherparatodos/src/repository/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductoDetailPage extends StatelessWidget {
  TextEditingController _codigoController;
  TextEditingController _descripcionController;
  TextEditingController _marcaController;
  TextEditingController _stockController;
  TextEditingController _precioController;
  TextEditingController _umController;

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
                        backgroundImage: prod.productoActual.imagen == null
                            ? AssetImage('assets/images/logo.png')
                            : NetworkImage(prod.productoActual.imagen),
                        radius: 40,
                      ),
                      onTap: () => getImage(ImageSource.gallery, prod),
                    ),
                    Text("Imagen")
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
              description: 'Precio unitario,'),
          EstadoHabilitado(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _updateAllData(context),
        label: const Text('Guardar'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Future getImage(ImageSource source, ProductoNotifier prod) async {
    final FireStorageService storage = FireStorageService.instance();
    ImagePicker.platform.pickImage(source: source).then((image) async {
      if (image != null) {
        await storage.uploadImage(image, prod.productoActual.codigo);
        await prod.changeImageName();
      }
    }).catchError((error) {
      print(error);
    });
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

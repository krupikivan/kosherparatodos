import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/Widget/show_toast.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/widgets/export.dart';
import 'package:provider/provider.dart';

class ProductoDetailPage extends StatefulWidget {
  final String image;
  final Producto producto;

  ProductoDetailPage({Key key, this.image, this.producto}) : super(key: key);

  @override
  _ProductoDetailPageState createState() => _ProductoDetailPageState();
}

class _ProductoDetailPageState extends State<ProductoDetailPage> {
  TextEditingController _codigoController;
  TextEditingController _descripcionController;
  TextEditingController _marcaController;
  TextEditingController _stockController;
  TextEditingController _precioController;
  TextEditingController _umController;

  @override
  void initState() {
    super.initState();
    _fillControllerData(widget.producto);
  }

  @override
  Widget build(BuildContext context) {
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
                        backgroundImage: NetworkImage(widget.image),
                        radius: 40,
                      ),
                      onTap: () => null,
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

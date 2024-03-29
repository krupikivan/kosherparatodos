import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/widgets/custom_icon.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class NewProducto extends StatefulWidget {
  @override
  _NewProductoState createState() => _NewProductoState();
}

class _NewProductoState extends State<NewProducto> {
  TextEditingController _codigoController;
  TextEditingController _descripcionController;
  TextEditingController _marcaController;
  TextEditingController _precioController;
  TextEditingController _stockController;
  TextEditingController _unidadMedidaController;
  File _image;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  bool _habilitado;

  @override
  void initState() {
    _codigoController = TextEditingController();
    _descripcionController = TextEditingController();
    _marcaController = TextEditingController();
    _precioController = TextEditingController();
    _stockController = TextEditingController();
    _unidadMedidaController = TextEditingController();
    _habilitado = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final CategoriaNotifier cateNot =
    //     Provider.of<CategoriaNotifier>(context, listen: false);
    // cateNot.getAllCategoriasHijos();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TitleText(
                    color: Colors.black,
                    text: 'Agregar nuevo Producto',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: _image == null
                              ? AssetImage('assets/images/logo.png')
                              : FileImage(_image),
                          radius: 20,
                        ),
                        onTap: () => choose(context),
                      ),
                      Text("Cargar imagen")
                    ],
                  ),
                ],
              ),
            ),
            InputDataField(
                controller: _codigoController,
                isNum: false,
                description: 'Codigo'),
            InputDataField(
                controller: _descripcionController,
                isNum: false,
                description: 'Descripcion'),
            InputDataField(
                controller: _marcaController,
                isNum: false,
                description: 'Marca'),
            InputDataField(
                controller: _precioController,
                isNum: true,
                description: 'Precio unitario'),
            InputDataField(
                controller: _stockController,
                isNum: true,
                description: 'Stock'),
            InputDataField(
                controller: _unidadMedidaController,
                isNum: false,
                description: 'Unidad Mediad'),
            ListTile(
              title: TitleText(
                text: _habilitado
                    ? 'Habilitado para el cliente'
                    : 'Deshabilitado para el cliente',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              leading:
                  Switch(value: _habilitado, onChanged: (val) => _changeBool()),
            ),

            agregarCategoriasButton(context),

            // CategoriaCheckboxWidget(
            //   esProducto: true,
            // ),
          ],
        ),
      ),
      floatingActionButton: Consumer<CategoriaNotifier>(
        builder: (context, cate, _) => FloatingActionButton.extended(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () =>
              _validateInputData() && cate.categoriaString.isNotEmpty
                  ? _addProduct(context)
                  : ShowToast().show('Faltan datos', 5),
          label: const Text('Agregar'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  void choose(BuildContext context) {
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
                  onPressed: () => getImage(ImageSource.gallery)
                      .then((value) => Navigator.pop(context)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('Abrir galeria'),
                      CustomIcon(icon: Icons.image, context: context),
                    ],
                  )),
              // FlatButton(
              //     onPressed: () => getImage(ImageSource.camera)
              //         .then((value) => Navigator.pop(context)),
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

  Future getImage(ImageSource source) async {
    await _getPermission();
    if (_permissionStatus == PermissionStatus.granted) {
      ImagePicker.pickImage(source: source).then((pickedFile) {
        if (pickedFile != null) {
          setState(() {
            _image = pickedFile;
          });
        }
      }).catchError((onError) {
        print(onError);
      });
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

  bool _validateInputData() {
    if (_codigoController.text != "" &&
        _descripcionController.text != "" &&
        _marcaController.text != "" &&
        _precioController.text != "" &&
        _stockController.text != "" &&
        _unidadMedidaController.text != "") {
      return true;
    }
    return false;
  }

  _setProductData() {
    final ProductoNotifier producto =
        Provider.of<ProductoNotifier>(context, listen: false);
    final Producto nuevo = Producto.fromTextEditingController(
      codigo: _codigoController.text,
      descripcion: _descripcionController.text,
      marca: _marcaController.text,
      precio: _precioController.text != ""
          ? double.parse(_precioController.text)
          : 0,
      stock: _stockController.text != "" ? int.parse(_stockController.text) : 0,
      unidadMedida: _unidadMedidaController.text,
      habilitado: _habilitado,
    );
    producto.creatingProducto(nuevo);
  }

  void _changeBool() {
    if (_habilitado == true) {
      _habilitado = false;
      setState(() {});
    } else {
      _habilitado = true;
      setState(() {});
    }
  }

  void _addProduct(BuildContext context) {
    try {
      _setProductData();
      Provider.of<ProductoNotifier>(context, listen: false)
          .addNewProducto(_image);
      Navigator.pop(context);
    } catch (e) {
      ShowToast().show('Algo salio mal', 5);
    }
  }
}

Widget agregarCategoriasButton(BuildContext context) {
  return MaterialButton(
    onPressed: () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AgregarCategorias()));
    },
    color: Theme.of(context).primaryColorLight,
    textColor: Theme.of(context).backgroundColor,
    child: Text('Categoria Del Producto'),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}

class AgregarCategorias extends StatelessWidget {
  const AgregarCategorias({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CategoriaNotifier categoria = Provider.of<CategoriaNotifier>(context);
    final ProductoNotifier producto = Provider.of<ProductoNotifier>(context);
    categoria.getHijos();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 20),
              child: TitleText(
                color: Colors.black,
                text: 'Seleccione la categoria del producto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: categoria.categoriaPadreList.length,
                itemBuilder: (BuildContext context, int i) {
                  final List<Categoria> list = categoria.categoriaHijoList
                      .where((element) => element.ancestro.contains(
                          categoria.categoriaPadreList[i].categoriaID))
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TitleText(
                        color: Colors.black,
                        text: categoria.categoriaPadreList[i].nombre,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      Container(
                        height: list.length <= 7 ? 60 : 110,
                        child: list.length <= 7
                            ? _HijosChips(
                                list: list,
                                categoria: categoria,
                                producto: producto)
                            : Column(
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    child: _HijosChips(
                                        list: list.sublist(
                                          0,
                                          (list.length / 2).truncate(),
                                        ),
                                        categoria: categoria),
                                  ),
                                  Container(
                                    height: 50,
                                    child: _HijosChips(
                                        list: list.sublist(
                                          (list.length / 2).floor(),
                                        ),
                                        categoria: categoria),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HijosChips extends StatelessWidget {
  const _HijosChips({
    Key key,
    @required this.list,
    @required this.categoria,
    this.producto,
  }) : super(key: key);

  final List<Categoria> list;
  final CategoriaNotifier categoria;
  final ProductoNotifier producto;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ChoiceChip(
            selected: list[index].selected,
            onSelected: (bool val) {
              val
                  ? categoria.categoriaString.add(list[index].categoriaID)
                  : categoria.categoriaString.remove(list[index].categoriaID);

              categoria.changeSelected(list[index].categoriaID, val, true);
              producto.addToCategoriaString(list[index].categoriaID, val);
            },
            label: Text(list[index].nombre),
          ),
        );
      },
    );
  }
}

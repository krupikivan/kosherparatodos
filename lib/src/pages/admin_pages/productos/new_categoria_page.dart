import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:provider/provider.dart';

class NewCategoria extends StatefulWidget {
  @override
  _NewCategoriaState createState() => _NewCategoriaState();
}

class _NewCategoriaState extends State<NewCategoria> {
  TextEditingController _nombreController;

  bool _esPadre;

  @override
  void initState() {
    _nombreController = TextEditingController();
    _esPadre = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CategoriaNotifier cateNot =
        Provider.of<CategoriaNotifier>(context, listen: false);
    cateNot.getAllCategorias();
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TitleText(
                color: MyTheme.Colors.black,
                text: 'Agregar nueva categoria',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            InputDataField(
                controller: _nombreController,
                isNum: false,
                description: 'Nombre'),
            _getHabilitado(),
            _esPadre == false
                ? const CategoriaCheckboxWidget(esProducto: false)
                : const SizedBox(
                    height: 1,
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addCategoria(context),
        label: const Text('Agregar'),
        backgroundColor: MyTheme.Colors.primary,
      ),
    );
  }

  _setCategoriaData() {
    final categoria = Provider.of<CategoriaNotifier>(context, listen: false);
    final Categoria nuevo = Categoria();
    nuevo.nombre = _nombreController.text;
    nuevo.esPadre = _esPadre;
    categoria.creatingCategoria(nuevo);
  }

  Widget _getHabilitado() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TitleText(
          text:
              _esPadre == true ? 'Es categoria padre' : 'No es categoria padre',
          fontSize: 15,
        ),
        IconButton(
          icon: Icon(
            Icons.check_circle,
            color: _esPadre == true ? Colors.green : Colors.red,
          ),
          onPressed: () => _changeBool(),
        ),
      ],
    );
  }

  void _changeBool() {
    if (_esPadre == true) {
      _esPadre = false;
      setState(() {});
    } else {
      _esPadre = true;
      setState(() {});
    }
  }

  void _addCategoria(BuildContext context) {
    _setCategoriaData();
    Provider.of<CategoriaNotifier>(context, listen: false).addNewCategoria();
    Navigator.pop(context);
  }
}

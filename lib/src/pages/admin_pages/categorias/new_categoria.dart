import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/widgets/export.dart';
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
    // final CategoriaNotifier cateNot =
    //     Provider.of<CategoriaNotifier>(context, listen: false);
    // cateNot.getAllCategoriasHijos();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                color: Colors.black,
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
      floatingActionButton: Consumer<CategoriaNotifier>(
        builder: (context, cate, _) => FloatingActionButton.extended(
          onPressed: () => !_esPadre
              ? _validateInputData() && cate.categoriaString.isNotEmpty
                  ? _addCategoria()
                  : ShowToast().show('Faltan datos', 5)
              : _validateInputData()
                  ? _addCategoria()
                  : ShowToast().show('Faltan datos', 5),
          label: const Text('Agregar'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  bool _validateInputData() {
    if (_nombreController.text != "") {
      return true;
    }
    return false;
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

  void _addCategoria() {
    try {
      final categoria = Provider.of<CategoriaNotifier>(context, listen: false);
      final Categoria nuevo =
          Categoria.fromNew(_nombreController.text, _esPadre, false);
      categoria.addNewCategoria(nuevo);
      Navigator.pop(context);
      ShowToast().show('Categoria agregada', 5);
    } catch (e) {
      ShowToast().show(e, 5);
    }
  }
}

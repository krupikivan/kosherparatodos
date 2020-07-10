import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/pages/user_pages/data/widgets/input_user_data.dart';
import 'package:kosherparatodos/src/pages/user_pages/historial_pedidos/bloc/bloc.dart';

class UserDataPage extends StatefulWidget {
  @override
  _UserDataPageState createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  TextEditingController _telController;
  TextEditingController _calleController;
  TextEditingController _aclaracionController;
  TextEditingController _ciudadController;
  TextEditingController _codigoPostController;
  TextEditingController _deptoController;
  TextEditingController _numeroController;
  TextEditingController _pisoController;
  TextEditingController _provinciaController;
  final _formKey = GlobalKey<FormState>();
  bool completed;
  @override
  void initState() {
    completed = false;
    _telController = TextEditingController();
    _calleController = TextEditingController();
    _aclaracionController = TextEditingController();
    _ciudadController = TextEditingController();
    _codigoPostController = TextEditingController();
    _deptoController = TextEditingController();
    _numeroController = TextEditingController();
    _pisoController = TextEditingController();
    _provinciaController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TitleText(
                color: Colors.black,
                text: 'Complete sus datos',
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(flex: 2, child: _userData()),
            Expanded(
              flex: 8,
              child: ListView(
                children: <Widget>[
                  StreamBuilder<Cliente>(
                    stream: blocUserData.getCliente,
                    builder: (context, snapshot) => !snapshot.hasData
                        ? CircularProgressIndicator()
                        : _formData(snapshot.data),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<Cliente>(
        stream: blocUserData.getCliente,
        builder: (context, snapshot) => !snapshot.hasData
            ? SizedBox()
            : FloatingActionButton.extended(
                onPressed: () => _editData(snapshot.data),
                label: const Text('Editar'),
                backgroundColor: Theme.of(context).primaryColor,
              ),
      ),
    );
  }

  Widget _userData() {
    return StreamBuilder<Cliente>(
      stream: blocUserData.getCliente,
      builder: (context, snapshot) => !snapshot.hasData
          ? CircularProgressIndicator()
          : Container(
              color: Theme.of(context).backgroundColor,
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                        leading: Icon(Icons.person,
                            color: Theme.of(context).primaryColor),
                        title: Text(
                            '${snapshot.data.nombre.nombre} ${snapshot.data.nombre.apellido}')),
                  ),
                  Expanded(
                    child: ListTile(
                        leading: Icon(Icons.email,
                            color: Theme.of(context).primaryColor),
                        title: Text(snapshot.data.email)),
                  ),
                ],
              ),
            ),
    );
  }

  ///TODO: VEr esto
  Widget _formData(Cliente cliente) {
    if (!completed) {
      _telController.text = cliente.telefono.toString() ?? "";
      _aclaracionController.text = cliente.direccion.aclaracion ?? "";
      _calleController.text = cliente.direccion.calle ?? "";
      _ciudadController.text = cliente.direccion.ciudad ?? "";
      _provinciaController.text = cliente.direccion.provincia ?? "";
      _pisoController.text = cliente.direccion.piso ?? "";
      _deptoController.text = cliente.direccion.depto ?? "";
      _codigoPostController.text =
          cliente.direccion.codigoPostal.toString() ?? "";
      _numeroController.text = cliente.direccion.numero.toString() ?? "";
      completed = true;
    }
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Theme.of(context).cardColor)),
      elevation: 3,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InputUserData(
                  controller: _telController,
                  error: 'Ingrese Telefono',
                  isNum: true,
                  title: 'Telefono'),
              InputUserData(
                  controller: _calleController,
                  error: 'Ingrese Calle',
                  isNum: false,
                  title: 'Calle'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InputUserData(
                        controller: _numeroController,
                        error: 'Ingrese Numero',
                        isNum: true,
                        title: 'Numero'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InputUserData(
                        controller: _pisoController,
                        error: 'Ingrese Piso',
                        isNum: false,
                        title: 'Piso - Lote'),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InputUserData(
                        controller: _deptoController,
                        error: 'Ingrese Dpto',
                        isNum: false,
                        title: 'Dpto - Mza'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InputUserData(
                        controller: _codigoPostController,
                        error: 'Ingrese Codigo Postal',
                        isNum: true,
                        title: 'Codigo Postal'),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InputUserData(
                        controller: _ciudadController,
                        error: 'Ingrese Ciudad',
                        isNum: false,
                        title: 'Ciudad'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InputUserData(
                        controller: _provinciaController,
                        error: 'Ingrese Provincia',
                        isNum: false,
                        title: 'Provincia'),
                  ),
                ],
              ),
              InputUserData(
                  controller: _aclaracionController,
                  error: 'Ingrese Aclaracion',
                  isNum: false,
                  title: 'Aclaracion')
            ],
          ),
        ),
      ),
    );
  }

  void _editData(Cliente cliente) async {
    if (_formKey.currentState.validate()) {
      try {
        final Map<String, dynamic> _address = {
          'aclaracion': _aclaracionController.text ?? "",
          'calle': _calleController.text ?? "",
          'ciudad': _ciudadController.text ?? "",
          'codigoPostal': _codigoPostController.text ?? "",
          'numero': _numeroController.text ?? "",
          'piso': _pisoController.text ?? "",
          'departamento': _deptoController.text ?? "",
          'provincia': _provinciaController.text ?? "",
        };
        final Cliente _cliente = Cliente.fromAddressEditing(cliente, _address);
        await blocUserData.userEdit(_cliente);
        blocUserData.setCliente(_cliente);
        ShowToast().show('Exitoso!', 5);
      } catch (e) {
        ShowToast().show(e, 5);
      }
    } else {
      ShowToast().show('Faltan datos', 5);
    }
  }
}

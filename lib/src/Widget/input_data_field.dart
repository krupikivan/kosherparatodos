import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:provider/provider.dart';

class InputDataField extends StatelessWidget {
  InputDataField({
    Key key,
    @required TextEditingController controller,
    @required bool isNum,
    @required String description,
    this.action,
    this.tipo,
  })  : _controller = controller,
        _isNum = isNum,
        _description = description,
        super(key: key);

  final VoidCallback action;
  final TextEditingController _controller;
  final bool _isNum;
  final String _description;
  final String tipo;

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<ProductoNotifier>(context, listen: false);
    return ListTile(
      title: TextField(
        onChanged: (value) => prod.setData(tipo, value),
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          filled: true,
        ),
        keyboardType: _isNum ? TextInputType.number : TextInputType.text,
        inputFormatters:
            _isNum ? [WhitelistingTextInputFormatter.digitsOnly] : null,
        controller: _controller,
      ),
      subtitle: Text(_description),
    );
  }
}

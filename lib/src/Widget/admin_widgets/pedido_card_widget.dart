import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class PedidoCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String estado;
  final bool pagado;
  final double elevation;
  final Color color;
  final VoidCallback action;
  const PedidoCardWidget(
      {Key key,
      this.action,
      this.elevation,
      this.color,
      this.title,
      this.subtitle,
      this.estado,
      this.pagado})
      : super(key: key);
// convert.getFechaFromTimestamp(fecha)
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:10, vertical: 2),
      child: Card(
        shadowColor: Colors.black38,
        color: color ?? MyTheme.Colors.white,
        elevation: elevation ?? 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 15),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.truck,
                size: 20,
                color: _getEstadoColor(),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.payment,
                size: 20,
                color: _getPagadoColor(),
              ),
            ],
          ),
          subtitle: Text(subtitle),
          onTap: action,
        ),
      ),
    );
  }

  MaterialColor _getEstadoColor() {
    switch (estado) {
      case 'Entregado':
        return Colors.green;
        break;
      case 'En Preparacion':
        return Colors.orange;
        break;
      case 'Cancelado':
        return Colors.red;
        break;
      default:
        return Colors.green;
    }
  }

  MaterialColor _getPagadoColor() {
    switch (pagado) {
      case true:
        return Colors.green;
        break;
      case false:
        return Colors.red;
        break;
      default:
        return Colors.red;
    }
  }
}

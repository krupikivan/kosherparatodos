import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/pedido.dart';

class PedidoCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String estado;
  final bool envio;
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
      this.pagado,
      this.envio})
      : super(key: key);
// convert.getFechaFromTimestamp(fecha)
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Card(
        shadowColor: Colors.black38,
        color: color ?? Colors.white,
        elevation: elevation ?? 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (envio  && estado != 'Entregado')
                  ? _StateIcon(asset: 'assets/icons/en_transito_100.png')
                  : SizedBox(),
              SizedBox(
                width: 10,
              ),
              (estado == 'En Preparacion')
                      ? _StateIcon(
                          asset: 'assets/icons/reloj_100.png',
                        )
                      : (estado == 'Cancelado')
                          ? _StateIcon(
                              asset: 'assets/icons/eliminar_100.png',
                            )
                          : SizedBox(),
              SizedBox(
                width: 10,
              ),
                pagado
                  ? _StateIcon(
                      asset: 'assets/icons/moneda_pagado_100.png',
                  )
                  : 
                  _StateIcon(
                      asset: 'assets/icons/moneda_no_pagado_100.png',
                  )
            ],
          ),
          subtitle: Text(subtitle),
          onTap: action,
        ),
      ),
    );
  }
}

class _StateIcon extends StatelessWidget {
  final String asset;
  const _StateIcon({
    Key key,
    this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      height: 30,
      alignment: Alignment.center,
    );
  }
}

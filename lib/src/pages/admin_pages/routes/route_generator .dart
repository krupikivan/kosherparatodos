import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/admin_pages/cliente_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/pedidos_page.dart';

class RouteGenerator  {
  static Route<dynamic> generateRoute(RouteSettings settings){
    // final args = settings.arguments;

    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => ClientePage());
      case '/clientes':
        return MaterialPageRoute(builder: (_) => ClientePage());
      case '/pedidos':
        return MaterialPageRoute(builder: (_) => PedidosPage());
      default:
        return _errorRoute();
    }
  }

static Route<dynamic> _errorRoute(){
  return MaterialPageRoute(builder: (_){
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(child: Text('Error'),),
    );
  });
}

}
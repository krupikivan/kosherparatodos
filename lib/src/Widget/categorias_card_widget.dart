import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';

class CategoriaCardWidget extends StatelessWidget {

  final CategoriaNotifier categoria;
  final int index;

  const CategoriaCardWidget({Key key, this.categoria, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => categoria.setPadreSelected(categoria.categoriaPadreList[index]),
          child: Container(
        width: 15,
        height: 15,
        margin: EdgeInsets.all(5),
            child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), 
            side: BorderSide(color: Colors.black87)
            ),
            elevation: 10,
           child: Center(child: Text(categoria.categoriaPadreList[index].nombre)),
        ),
      ),
    );
  }
}
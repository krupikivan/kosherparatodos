import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kosherparatodos/src/Widget/user_widgets/producto_widget.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'bloc/bloc.dart';

class ProductoGridPage extends StatefulWidget {
  @override
  _ProductoGridPageState createState() => _ProductoGridPageState();
}

class _ProductoGridPageState extends State<ProductoGridPage> {
  @override
  void initState() {
    super.initState();
    blocProductos.getProductosHabilitados();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: StreamBuilder<List<Producto>>(
          stream: blocProductos.getProductosVigentes,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(MyTheme.Colors.accent),
              ));
            else
              return StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: snapshot.data.length,
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.count(2, 3.2),
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductoItemWidget(producto: snapshot.data[index]);
                  });
          }),
    );
  }
}

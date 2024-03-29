import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/pages/user_pages/widgets/product_card.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/categoria_provider.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/widgets/categoria_card_hijo.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/widgets/categoria_card_padre.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/widgets/search.dart';
import 'package:kosherparatodos/src/repository/firebase_storage.dart';
import 'package:provider/provider.dart';

class ProductoGridPage extends StatefulWidget {
  @override
  _ProductoGridPageState createState() => _ProductoGridPageState();
}

class _ProductoGridPageState extends State<ProductoGridPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<FireStorageService>(context, listen: false);
    return Consumer<CategoriaProvider>(
      builder: (context, cate, _) => Column(
        children: <Widget>[
          Search(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
            child: Container(
              height: cate.categoriaHijoList.isNotEmpty ? 100 : 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cate.categoriaList.length,
                        itemBuilder: (context, index) =>
                            cate.categoriaList[index].esPadre
                                ? CategoriaCardPadre(
                                    action: () => cate.changePadreSelected(
                                        cate.categoriaList[index]),
                                    selected: cate.categoriaList
                                        .elementAt(index)
                                        .selected,
                                    categoria: cate.categoriaList[index].nombre,
                                  )
                                : SizedBox()),
                  ),
                  cate.categoriaHijoList.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: cate.categoriaHijoList.length,
                              itemBuilder: (context, index) =>
                                  CategoriaCardHijo(
                                    selected: cate.categoriaHijoList
                                        .elementAt(index)
                                        .selected,
                                    action: () => cate.getProductos(
                                        cate.categoriaHijoList[index]),
                                    categoria:
                                        cate.categoriaHijoList[index].nombre,
                                  )),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          cate.productoList.isNotEmpty &&
                  cate.categoriaHijoList.any((element) => element.selected)
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                              height: 5,
                              color: Colors.transparent,
                            ),
                        itemCount: cate.productoList.length,
                        itemBuilder: (BuildContext context, int index) => cate
                                .sortProd(cate.productoList.elementAt(index))
                            ? FutureBuilder<Object>(
                                future: storage
                                    .getImage(cate.productoList[index].codigo),
                                builder: (context, snapshot) => snapshot.hasData
                                    ? ProductoCard(
                                        imagen: snapshot.data,
                                        producto: cate.productoList[index])
                                    : ShimmerListLoadingEffect(),
                              )
                            : SizedBox()),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

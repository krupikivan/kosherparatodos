import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListLoadingEffect extends StatelessWidget {
  const ShimmerListLoadingEffect({Key key, this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    double containerHeight = 10;
    double containerWidth = 180;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[400],
        highlightColor: Colors.white,
        child: Container(
          // height: 60,
          // margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          margin: EdgeInsets.symmetric(vertical: 7.5),
          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 60.0,
                height: 60.0,
                margin: EdgeInsets.only(right: 15.0),
                color: Colors.blue,
              ),
              /*index != -1
                  ?*/
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: containerHeight,
                    width: containerWidth,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: containerHeight,
                    width: containerWidth,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: containerHeight,
                    width: containerWidth - 40,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5),
                ],
              )
              /*: Expanded(
                      child: Container(
                        color: Colors.grey,
                      ),
                    )*/
            ],
          ),
        ),
      ),
    );
  }
}

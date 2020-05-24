import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  TestPage({Key key}) : super(key: key);
  Firestore fire = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: fire.collection('categorias').snapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) { 
                  DocumentReference ref = fire.collection('categorias').document(snapshot.data.documents[index].documentID);
                  return ListTile(
                  title: Text(snapshot.data.documents[index].documentID),
                );
                }
                );
            }
          ),
                    StreamBuilder<QuerySnapshot>(
            stream: fire.collection('categorias').document().collection('hijo').snapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) => ListTile(
                  title: Text(snapshot.data.documents[index].data['nombre']),
                ),
                );
            }
          ),
        ],
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../firebase_services.dart';

class DataSearch extends SearchDelegate<String> {
  final FirebaseServices _services = FirebaseServices();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () {}, icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _services.produtos.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            print(snapshot.data);
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element['productName']
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                    .map(
                  (QueryDocumentSnapshot<Object?> data) {
                    final String productName = data['productName'];
                    final String regularPrice = data['regularPrice'];
                    final String productImage = data['productImage'];

                    return ListTile(
                        onTap: () {},
                        title: Text(productName),
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(productImage)),
                        subtitle: Text(
                          regularPrice,
                        ));
                  },
                )
              ],
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Procure por produtos"),
    );
  }
}

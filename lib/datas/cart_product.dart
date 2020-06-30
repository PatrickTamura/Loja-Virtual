import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:primeiro_app/datas/product_data.dart';

class CartProduct {

  String cid;

  String category;
  String pid;

  int quantity;
  String size;
  String description;

  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    category = document.data["category"];
    pid = document.data["pid"];
    quantity = document.data["quantity"];
    size = document.data["size"];
    description = document.data["description"];
  }

  Map<String, dynamic> toMap(){
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      "description": description,
      "product": productData.toResumedMap()
    };
  }

}
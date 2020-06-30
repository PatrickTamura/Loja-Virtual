import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primeiro_app/datas/cart_product.dart';
import 'package:primeiro_app/models/cart_model.dart';
import 'package:primeiro_app/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';



class CartPrice extends StatelessWidget {

  final VoidCallback buy;


  CartPrice(this.buy);
  


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ScopedModelDescendant<CartModel>(
        builder: (context, child, model){

          double price = model.getProductsPrice();
          double discount = model.getDiscount();
          double ship = model.getShipPrice();
          String description = model.getDescription();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Resumo do Pedido",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 12.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Subtotal"),
                  Text("R\$ ${price.toStringAsFixed(2)}")
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Desconto"),
                  Text("R\$ ${discount.toStringAsFixed(2)}")
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Entrega"),
                  Text("R\$ ${ship.toStringAsFixed(2)}")
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Observação: "),
                  Text("${description}")
                ],
              ),
              Divider(),
              SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total",
                  style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text("R\$ ${(price + ship - discount).toStringAsFixed(2)}",
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),
                  )
                ],
              ),
              SizedBox(height: 12.0),
              RaisedButton(
                child: Text("Finalizar Pedido"),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: buy,
              ),
              RaisedButton(
                child: Text("Cancelar Pedido"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: (){
                  showAlertDialog2(context);

                }
              )
            ],
          );
        },
      )
    );
  }


showAlertDialog2(BuildContext context) {
   Widget cancelaButton = FlatButton(
    child: Text("Cancelar"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continuaButton = FlatButton(
    child: Text("Continuar"),
    onPressed:  () {
      CartModel.of(context).cancelOrder();
      Navigator.of(context).pop();
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Compra cancelada"),
        backgroundColor: Theme.of(context).primaryColor,
    ));
 
    },
  );
  //configura o AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("CANCELAR A COMPRA"),
    content: Text("REALMENTE DESEJA CANCELAR A COMPRA?"),
    actions: [
      cancelaButton,
      continuaButton,
    ],
  );
  //exibe o diálogo
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
  

}
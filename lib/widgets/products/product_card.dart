import 'package:flutter/material.dart';
import './price_tag.dart';
import '../ui_elements/title_default.dart';
import './address_tag.dart';
class ProductCard extends StatelessWidget {
  final Map<String, dynamic>products;
  final int productIndex;
  ProductCard(this.products, this.productIndex);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products['image']),
          Container(
            padding: EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TitleDefault(products['title']),
                SizedBox(width: 20.0),
                PriceTag(products['price'].toString()),
              ],
            ),
          ),

          SizedBox(height: 10.0,),
          AddressTag('Union Square'),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info,size: 40,),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + productIndex.toString()),
              ),
              SizedBox(width: 10,),
              IconButton(
                icon: Icon(Icons.favorite_border,size: 40,),
                color: Colors.red,
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + productIndex.toString()),
              )
            ],
          )
        ],
      ),
    );
  }
}

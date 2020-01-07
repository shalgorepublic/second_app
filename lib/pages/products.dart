import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/products/products.dart';
import '../scoped_models/main.dart';
import '../widgets/ui_elements/logout_list_tile.dart';
import './task_screen.dart';
class ProductsPage extends StatefulWidget {
  final MainModel model;
  ProductsPage(this.model);
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  initState(){
    widget.model.fetchProducts();
    super.initState();
  }
  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Task Page'),
            onTap: () {
              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => TaskScreen()));
            },
          ),
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Products Found!'));
        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = SafeArea(child:Products());
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchProducts,child: content);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return
      ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child, MainModel model){
      return  SafeArea(top: false,child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text(model.displayFavouritesOnly ? 'Fovourites Products' :'List Of All Products'),
          actions: <Widget>[
            IconButton(
              icon: Icon(model.displayFavouritesOnly ?
              Icons.favorite:Icons.favorite_border,
                size: 30,
              ),
              onPressed: () {
                model.toggleDisplayMode();
              },
            )
          ],
        ),
        body: _buildProductsList(),
      ));

      },);
  }
}

import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  String _selProductId;
  User _authenthicatedUser;
  bool _isLoading = false;
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFavourite = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavourite) {
      return _products.where((Product product) => product.isFaviurite).toList();
    }

    return List.from(_products);
  }

  int get  selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }
    String get selectedProductId {
      return _selProductId;
    }

    Product get selectedProduct {
      if (selectedProductId == null) {
        return null;
      }
      return _products.firstWhere((Product product){
        return product.id == _selProductId;
      });
    }

    bool get displayFavouritesOnly{
      return _showFavourite;
    }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
      'https://media.self.com/photos/5d1a2670cd03b000088d74bb/4:3/w_728,c_limit/cbd-skincare.jpg',
      'price': price,
      'userEmail': _authenthicatedUser.email,
      'userId': _authenthicatedUser.id
    };
    try {
      final http.Response response = await http
          .post('https://flutter-projects-1d118.firebaseio.com/projects.json' ,
          body: json.encode(productData));
      if (response.statusCode != 200 && response.statusCode != 210) {
        _isLoading = false;
        print(response);
        notifyListeners();
        return false;
      }
      final Map<String , dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'] ,
          title: title ,
          description: description ,
          image: image ,
          price: price ,
          userEmail: _authenthicatedUser.email ,
          userId: _authenthicatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error){
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

    Future<bool> updateProduct(
        String title, String description, String image, double price) {
      _isLoading = true;
      notifyListeners();
      final Map<String, dynamic> updateData = {
        'title': title,
        'description': description,
        'image':
        'https://media.gettyimages.com/photos/luxury-mixed-chocolate-truffles-picture-id155097702',
        'price': price,
        'userEmail': selectedProduct.userEmail,
        'userId': selectedProduct.userId
      };
      return http
          .put(
          'https://flutter-projects-1d118.firebaseio.com/projects/${selectedProduct.id}.json',
          body: json.encode(updateData))
          .then((http.Response reponse) {
        _isLoading = false;
        final Product updatedProduct = Product(
            id: selectedProduct.id,
            title: title,
            description: description,
            image: image,
            price: price,
            userEmail: selectedProduct.userEmail,
            userId: selectedProduct.userId);
        _products[selectedProductIndex] = updatedProduct;
        notifyListeners();
        return true;
      }).
      catchError((error){
        _isLoading = false;
        notifyListeners();
        return false;
      });
    }

    Future<bool> deleteProduct() {
      _isLoading = true;
      final deletedProductId = selectedProduct.id;
      _products.removeAt(selectedProductIndex);
      _selProductId = null;
      notifyListeners();
      return http
          .delete(
          'https://flutter-projects-1d118.firebaseio.com/projects/${deletedProductId}.json')
          .then((http.Response response) {
        _isLoading = false;
        notifyListeners();
        return true;
      }).
      catchError((error){
        _isLoading = false;
        notifyListeners();
        return false;
      });
    }

    void selectProduct(String productId) {
      _selProductId = productId;
      notifyListeners();
    }

    Future<Null> fetchProducts() {
      _isLoading = true;
      return http
          .get('https://flutter-projects-1d118.firebaseio.com/projects.json')
          .then<Null>((http.Response response) {
        final List<Product> fetchedProductList = [];
        print(response.body);
        final Map<String, dynamic> productListData = jsonDecode(response.body);
        if (productListData == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }
        productListData.forEach((String productId, dynamic productData) {
          final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            userId: productData['userId'],
          );
          fetchedProductList.add(product);
        });
        _products = fetchedProductList;
        _isLoading = false;

        notifyListeners();
        _selProductId = null;
      }).
      catchError((error){
        _isLoading = false;
        notifyListeners();
        return false;
      });
    }

    void toggleProductFavouriteStatus() {
      final bool isCurrentlyFavourite =
       _products[selectedProductIndex].isFaviurite;
      final newFavouriteStatus = !isCurrentlyFavourite;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFaviurite: newFavouriteStatus);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    }

    void toggleDisplayMode() {
      _showFavourite = !_showFavourite;
      notifyListeners();
    }
  }


class UserModel extends ConnectedProductsModel {
  void login(String email, String password) {
    _authenthicatedUser = User(id: 'abhdbab', email: email, password: password);
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}

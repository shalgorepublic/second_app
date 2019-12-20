import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import '../models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  int get selectedProductIndex {
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
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavouritesOnly {
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
      final http.Response response = await http.post(
          'https://flutter-projects-1d118.firebaseio.com/projects.json?auth=${_authenthicatedUser.token}',
          body: json.encode(productData));
      if (response.statusCode != 200 && response.statusCode != 210) {
        _isLoading = false;
        print(response);
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenthicatedUser.email,
          userId: _authenthicatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
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
            'https://flutter-projects-1d118.firebaseio.com/projects/${selectedProduct.id}.json?auth=${_authenthicatedUser.token}',
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
    }).catchError((error) {
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
            'https://flutter-projects-1d118.firebaseio.com/projects/${deletedProductId}.json?auth=${_authenthicatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
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
        .get(
            'https://flutter-projects-1d118.firebaseio.com/projects.json?auth=${_authenthicatedUser.token}')
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
    }).catchError((error) {
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
  User get user{
    return _authenthicatedUser;
  }
  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String , dynamic> authData = {
      'email': email ,
      'password': password ,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCQd9Oa58EfSEAvpSX_fIpCVTK0cGoscrE' ,
        body: json.encode(authData) ,
        headers: {'Content-Type': 'application/json'} ,
      );
    } else {
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCQd9Oa58EfSEAvpSX_fIpCVTK0cGoscrE' ,
        body: json.encode(authData) ,
        headers: {'Content-Type': 'application/json'} ,
      );
    }

    print(json.decode(response.body));
    print("helo response");
    final Map<String , dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    print(responseData['error']);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication Succeeded';
      _authenthicatedUser = User(
          id: responseData['localID'] ,
          email: email ,
          token: responseData['idToken']);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token' , responseData['idToken']);
      prefs.setString('userEmail' , email);
      prefs.setString('userId' , responseData['localId']);
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This Email is already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This Email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError , 'message': message};
  }
    void autoAuthenticate() async{
      final SharedPreferences prefs =  await SharedPreferences.getInstance();
      final String token = prefs.get('token');
      if(token != null){
        final String userEmail = prefs.get('userEmail');
        final String userId = prefs.get('userId');
        _authenthicatedUser = User(id: userId,email: userEmail,token: token);
        notifyListeners();
        print(_authenthicatedUser);
      }
  }
  void logout() async {
    print('Logout');
    _authenthicatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}

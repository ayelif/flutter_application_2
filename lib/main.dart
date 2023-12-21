import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Uygulama',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;

                if (username.isNotEmpty && password.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(username: username),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: 'Kullanıcı adı ve şifre gerekli!',
                    toastLength: ToastLength.SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class Fluttertoast {
  static void showToast({
    required String msg,
    required ToastLength toastLength,
    required ToastGravity gravity,
    required Color backgroundColor,
    required Color textColor,
  }) {
    Fluttertoast.showToast(
      msg: 'Kullanıcı adı ve şifre gerekli!',
      toastLength: ToastLength.SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}

// ignore: constant_identifier_names
enum ToastLength { SHORT, LONG }

// ignore: constant_identifier_names
enum ToastGravity { TOP, BOTTOM, CENTER }

class ProductPage extends StatelessWidget {
  final String username;

  const ProductPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $username!'),
      ),
      body: const ProductList(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Sepetiniz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Sepete Git'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductTile(product: products[index]);
      },
    );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(product.imageURL),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.name),
          ),
          ElevatedButton(
            onPressed: () {
              addToCart(product);
              _showAddToCartDialog(context, product);

              Fluttertoast.showToast(
                msg: '${product.name} sepete eklendi',
                toastLength: ToastLength.SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
            },
            child: const Text('Sepete Ekle'),
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
// class _showAddToCartDialog {
//   _showAddToCartDialog(BuildContext context, Product product);
// }
void _showAddToCartDialog(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Ürün Eklendi'),
        content: Text('${product.name} sepete eklendi.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Tamam'),
          ),
        ],
      );
    },
  );
}

void addToCart(Product product) {
  // Ürünü sepet listesine ekle
  final existingProductIndex =
      cartProducts.indexWhere((p) => p.name == product.name);

  if (existingProductIndex != -1) {
    cartProducts[existingProductIndex].quantity++;
  } else {
    product.quantity = 1;
    cartProducts.add(product);
  }
}

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetiniz'),
      ),
      body: const CartList(),
    );
  }
}

class CartList extends StatelessWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartProducts.length,
      itemBuilder: (context, index) {
        final product = cartProducts[index];
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ignore: unnecessary_string_interpolations
              Text('${product.name}'),
              Text('Adet: ${product.quantity}'),
            ],
          ),
          leading: Image.asset(product.imageURL),
        );
      },
    );
  }
}

List<Product> cartProducts = [];

class Product {
  final String name;
  final String imageURL;
  int quantity;

  Product({
    required this.name,
    required this.imageURL,
    this.quantity = 0,
  });
}

List<Product> products = [
  Product(name: 'Keman', imageURL: 'assets/images/keman.jpeg'),
  Product(name: 'Gitar', imageURL: 'assets/images/gitar.jpeg'),
  Product(name: 'Piyano', imageURL: 'assets/images/piyano.jpeg'),
];

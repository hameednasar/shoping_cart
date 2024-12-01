import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Product Model
class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

// CartController to manage the cart state
class CartController extends GetxController {
  RxList<Product> cartItems = <Product>[].obs;

  // Add product to cart
  void addToCart(Product product) {
    cartItems.add(product);
  }

  // Remove product from cart
  void removeFromCart(Product product) {
    cartItems.remove(product);
  }

  // Calculate total price
  double get totalPrice => cartItems.fold(0.0, (sum, item) => sum + item.price);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductListPage(),
    );
  }
}

// Product List Page to display products
class ProductListPage extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    // Sample product list
    List<Product> products = [
      Product(name: "Apple", price: 1.5),
      Product(name: "Banana", price: 1.0),
      Product(name: "Orange", price: 2.0),
      Product(name: "Mango", price: 3.0),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, size: 30),
            onPressed: () {
              Get.to(() => CartPage());
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange, Colors.pink, Colors.blue],
          ),
        ),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              color: Colors.white70,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.all(15),
                title: Text(
                  product.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle:
                    Text("\$${product.price}", style: TextStyle(fontSize: 16)),
                trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart, color: Colors.deepPurple),
                  onPressed: () {
                    cartController.addToCart(product);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Cart Page to display items in the cart
class CartPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          Obx(() {
            if (cartController.cartItems.isEmpty) {
              return Center(
                  child: Text("Your cart is empty",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)));
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return Card(
                      color: Colors.white70,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        title: Text(
                          item.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("\$${item.price}",
                            style: TextStyle(fontSize: 16)),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_shopping_cart,
                              color: Colors.red),
                          onPressed: () {
                            cartController.removeFromCart(item);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }),
          Divider(),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Total: \$${cartController.totalPrice}",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            );
          }),
        ],
      ),
    );
  }
}

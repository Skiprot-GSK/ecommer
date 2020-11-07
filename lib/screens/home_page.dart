import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delgroce/screens/contact_us_page.dart';
import 'package:delgroce/screens/offres_page.dart';
import 'package:delgroce/screens/payment_options_page.dart';
import 'package:delgroce/screens/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:delgroce/screens/PurchaseHistory.dart';

import 'faq_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;

  Future<void> getUserData() async {
    User userData = await FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
      print(userData.uid);
    });
  }

  Future<void> getUser() async {
    DocumentSnapshot cn = await FirebaseFirestore.instance
        .collection('users')
        .doc('${user.uid}')
        .get();
    return cn;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getUser();
  }

  // startBarcodeScanStream() async {
  //   FlutterBarcodeScanner.getBarcodeStreamReceiver(
  //           "#ff6666", "Cancel", true, ScanMode.BARCODE)
  //       .listen((barcode) => print(barcode));
  // }
  //
  // Future<void> scanQR() async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         "#ff6666", "Cancel", true, ScanMode.QR);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  // }
  //
  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         "#ff6666", "Cancel", true, ScanMode.BARCODE);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   if (barcodeScanRes != '-1' || null) {
  //     return showDialog(
  //         context: context,
  //         builder: (context) {
  //           return StreamBuilder(
  //               stream: Firestore.instance
  //                   .collection("products")
  //                   .where("barcode", isEqualTo: '$barcodeScanRes')
  //                   .snapshots(),
  //               builder: (context, snapshot) {
  //                 if (!snapshot.hasData) {
  //                   return Dialog(
  //                     child: Container(
  //                       height: 300,
  //                       child: Text('Product Not Found'),
  //                     ),
  //                   );
  //                 } else {
  //                   return Dialog(
  //                     child: Container(
  //                       height: 350,
  //                       child: Column(children: [
  //                         Container(
  //                             height: 350,
  //                             width: 165,
  //                             child: ListView.builder(
  //                               scrollDirection: Axis.horizontal,
  //                               itemCount: snapshot.data.documents.length,
  //                               itemBuilder: (context, index) {
  //                                 DocumentSnapshot products =
  //                                     snapshot.data.documents[index];
  //                                 return ScanCard(products: products);
  //                               },
  //                             )),
  //                       ]),
  //                     ),
  //                   );
  //                 }
  //               });
  //         });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[240],
      // floatingActionButton: floatingBar(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: buildAppBar(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            FutureBuilder(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return UserAccountsDrawerHeader(
                        currentAccountPicture: new CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: (snapshot.data['avatar'] == null ||
                                    snapshot.data['avatar'] == '')
                                ? NetworkImage(
                                    "https://cdn2.iconfinder.com/data/icons/website-icons/512/User_Avatar-512.png")
                                : NetworkImage(
                                    snapshot.data['avatar'],
                                  )),
                        accountName: Text(
                          "Name: ${snapshot.data['displayName']}",
                          style: TextStyle(fontSize: 15),
                        ),
                        accountEmail: Text(
                          "Email: ${snapshot.data['email']}",
                          style: TextStyle(fontSize: 15),
                        ));
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "My Profile",
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text(
                "My Orders",
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PurchaseHistory()));
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text(
                "Payment Options",
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PaymentOptions()));
              },
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text(
                "Offers",
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => OffersPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text(
                "Contact Us",
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ContactUs()));
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text(
                "FAQs",
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => FAQPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                "Log out",
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut().then(
                  (value) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/loginpage', (Route<dynamic> route) => false);
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  // color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 8, right: 8, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.red,
                    ),
                    title: TextField(
                      textInputAction: TextInputAction.search,
                      // onSubmitted: (pattern)async{
                      //   app.changeLoading();
                      //   if(app.search == SearchBy.PRODUCTS){
                      //     await productProvider.search(productName: pattern);
                      //     changeScreen(context, ProductSearchScreen());
                      //   }else{
                      //     await restaurantProvider.search(name: pattern);
                      //     changeScreen(context, RestaurantsSearchScreen());
                      //   }
                      //   app.changeLoading();
                      // },
                      decoration: InputDecoration(
                        hintText: "Use me to find it quick",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            // Text("Categories"),
            // SizedBox(
            //   height: 10,
            // ),
            // Container(
            //   height: 110,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           children: [
            //             FloatingActionButton(
            //               child: Icon(Icons.fastfood),
            //             ),
            //             SizedBox(
            //               height: 10,
            //             ),
            //             Text('Fast Food')
            //           ],
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           children: [
            //             FloatingActionButton(
            //               child: Icon(Icons.fastfood),
            //             ),
            //             SizedBox(
            //               height: 10,
            //             ),
            //             Text('Fast Food')
            //           ],
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           children: [
            //             FloatingActionButton(
            //               child: Icon(Icons.fastfood),
            //             ),
            //             SizedBox(
            //               height: 10,
            //             ),
            //             Text('Fast Food')
            //           ],
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           children: [
            //             FloatingActionButton(
            //               child: Icon(Icons.fastfood),
            //             ),
            //             SizedBox(
            //               height: 10,
            //             ),
            //             Text('Fast Food')
            //           ],
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           children: [
            //             FloatingActionButton(
            //               child: Icon(Icons.fastfood),
            //             ),
            //             SizedBox(
            //               height: 10,
            //             ),
            //             Text('Fast Food')
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Vegetables',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
              ),
            ),
            buildStreamVegetables(),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Fruits',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
              ),
            ),
            buildStreamFruits(),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Dairy',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
              ),
            ),
            buildStreamDairy()
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> buildStreamVegetables() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("category", isEqualTo: "vegetables")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Text(
              'Loading',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          return Container(
              height: 240,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot products = snapshot.data.docs[index];
                    return ItemCard(products: products);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10);
                  }));
        });
  }

  StreamBuilder<QuerySnapshot> buildStreamFruits() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("category", isEqualTo: "fruits")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Text(
              'Loading',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          return Container(
              height: 240,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot products = snapshot.data.docs[index];
                    return ItemCard(products: products);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10);
                  }));
        });
  }

  StreamBuilder<QuerySnapshot> buildStreamDairy() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("category", isEqualTo: "dairy")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Text(
              'Loading',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          return Container(
              height: 240,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot products = snapshot.data.docs[index];
                    return ItemCard(products: products);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10);
                  }));
        });
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.teal,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        "Delgroce",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/cartpage');
          },
        )
      ],
    );
  }

  // Widget floatingBar() => Ink(
  //       decoration: ShapeDecoration(
  //         shape: StadiumBorder(),
  //       ),
  //       child: FloatingActionButton.extended(
  //         onPressed: () {
  //           scanBarcodeNormal();
  //         },
  //         backgroundColor: Colors.black,
  //         icon: Icon(
  //           FontAwesomeIcons.barcode,
  //           color: Colors.white,
  //         ),
  //         label: Text(
  //           "SCAN",
  //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //     );
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key key,
    @required this.products,
  }) : super(key: key);

  final DocumentSnapshot products;

  @override
  Widget build(BuildContext context) {
    String _userId;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
    }
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blueAccent)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // padding: EdgeInsets.all(20.0),
            height: 150,
            width: 160,
            decoration: BoxDecoration(
                // color: Color(0xFF3D82AE),
                borderRadius: BorderRadius.circular(16)),
            child: Image.network(products['img']),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
            child: Text(
              products['name'],
              style: TextStyle(
                color: Color(0xFF535353),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "\R " + products['price'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 60,
              ),
              GestureDetector(
                child: Icon(
                  // CupertinoIcons.cart_fill_badge_plus,
                  Icons.shopping_cart,
                  color: Colors.black,
                  size: 30,
                ),
                onTap: () {
                  DocumentReference documentReference = FirebaseFirestore
                      .instance
                      .collection('userData')
                      .doc(_userId)
                      .collection('cartData')
                      .doc();
                  documentReference
                      .set({
                        'uid': _userId,
                        // 'barcode': products['barcode'],
                        'img': products.data()['img'],
                        'name': products.data()['name'],
                        // 'netweight': products['netweight'],
                        'price': products.data()['price'],
                        'id': documentReference.id
                      })
                      .then((result) {})
                      .catchError((e) {
                        print(e);
                      });
                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text(
                      'Added to Cart',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.start,
                    ),
                    duration: Duration(milliseconds: 300),
                    backgroundColor: Color(0xFF3D82AE),
                  ));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ScanCard extends StatelessWidget {
  const ScanCard({
    Key key,
    @required this.products,
  }) : super(key: key);
  final DocumentSnapshot products;

  @override
  Widget build(BuildContext context) {
    String _userId;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          height: 180,
          width: 160,
          decoration: BoxDecoration(
              color: Color(0xFF3D82AE),
              borderRadius: BorderRadius.circular(16)),
          child: Image.network(products['img']),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
          child: Text(
            products['name'],
            style: TextStyle(
              color: Color(0xFF535353),
              fontSize: 18,
            ),
          ),
        ),
        // Column(
        //   children: [
        //     Text(
        //       "netweight- " + products['netweight'],
        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        //     ),
        //     SizedBox(
        //       width: 30,
        //     ),
        //   ],
        // ),
        Row(
          children: [
            Text(
              "\R " + products['price'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              width: 60,
            ),
            Icon(
              Icons.add_shopping_cart,
              color: Colors.black,
              size: 27,
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Color(0xFF3D82AE),
              child: Text(
                "Add to cart",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                DocumentReference documentReference = FirebaseFirestore.instance
                    .collection('userData')
                    .doc(_userId)
                    .collection('cartData')
                    .doc();
                documentReference.set({
                  'uid': _userId,
                  // 'barcode': products['barcode'],
                  'img': products.data()['img'],
                  'name': products.data()['name'],
                  // 'netweight': products['netweight'],
                  'price': products.data()['price'],
                  'id': documentReference.id
                }).then((result) {
                  dialogTrigger(context);
                }).catchError((e) {
                  print(e);
                });
              },
            ),
          ),
        )
      ],
    );
  }
}

Future<bool> dialogTrigger(BuildContext context) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Job done', style: TextStyle(fontSize: 22.0)),
          content: Text(
            'Added Successfully',
            style: TextStyle(fontSize: 20.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Alright',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

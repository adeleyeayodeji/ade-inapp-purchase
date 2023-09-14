import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

//For network resolution
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();

  if (Platform.isIOS) {
    //initialise purchases
    await Purchases.setDebugLogsEnabled(false);
    try {
      // var appleUseId = await getData("iosUserId");
      var appleUseId = "user2345533";
      await Purchases.setup("your_key",
          appUserId: appleUseId);
    } catch (e) {
      await Purchases.setup("your_key");
    }
  }

  runApp(MaterialApp(
    title: 'RevenueCat Sample',
    home: InitialScreen(),
  ));
}

class InitialScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<InitialScreen> {
  late PurchaserInfo _purchaserInfo;
  dynamic productIOS = null;
  bool buyNow = false;
  String productIdData = "product_9999";
  String pro_ID = "product_33444";
  String productId3 = "product_33441";
  List alreadyPurchased = [];

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    //pass all the products to the list
    purchaserInfo.allPurchasedProductIdentifiers.forEach((element) {
      alreadyPurchased.add(element);
    });
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _purchaserInfo = purchaserInfo;
    });
  }

  Future<void> purchasedAppStore(String productIdInput) async {
    Product myProduct;

    try {
      String myProductPrice = "";
      String myProductPriceString = "";
      await Purchases.getProducts(["$productIdInput"])
          .then((value) async => {
            //toast
        if(value.isEmpty){
          await Fluttertoast.showToast(
                    msg: "Product does not exist",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0)
        }else{
          await Fluttertoast.showToast(
              msg: "Product exist",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0)
        },
                if (mounted)
                  setState(() {
                    buyNow = value.isEmpty ? false : true;
                    productIOS = value.isEmpty ? null : value[0];
                  }),
                myProduct = value[0],
                // Get Product Price from apple and convert to string
                myProductPrice = myProduct.price.toString(),
                // Get Product String Price including the currently from apple servers
                myProductPriceString = myProduct.priceString,
                //TODO: edit the courseData.originPrice as needed using the above strings;
              })
      .catchError((e) => {
        //toast
        Fluttertoast.showToast(
            msg: "Product does not exist",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0),
        //set state
        if (mounted)
          setState(() {
            buyNow = false;
          })
      });

    } on Exception catch (e) {
      debugPrint(e.toString() + "error");
      if (mounted)
        setState(() {
          buyNow = false;
        });
    }
  }

  ///Version 2 check if product exist
  Future<bool> checkProductExist(String proId) async {
    try {
       var response = await Purchases.getProducts(["$proId"]);
        if(response.isEmpty){
          return false;
        }else{
          return true;
        }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("RevenueCat Sample App")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //input
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter product id",
                      //remove border and add bg light grey
                      border: InputBorder.none,
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CupertinoButton(
                    //bg black
                    color: Colors.black,
                    onPressed: () async {
                      //check if input is empty
                      if (_controller.text.isEmpty) {
                        //toast
                        await Fluttertoast.showToast(
                            msg: "Enter product id",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      //get product id from input
                      var input = _controller.text;
                    await purchasedAppStore(input);
                }, child: Text("Check product exist")),
                SizedBox(height: 20),
                ElevatedButton(onPressed: () async {
                  if (Platform.isIOS) {
                  //check if alreadyPurchased
                  if (alreadyPurchased.contains(productIdData)) {
                    //toast
                    await Fluttertoast.showToast(
                        msg: "You already purchased this product",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }
                  //check if product exist
                  var productExist = await checkProductExist(productIdData);
                  if (!productExist) {
                    //toast
                    await Fluttertoast.showToast(
                        msg: "Product does not exist",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }
                  //make payment
                    await iosPayment(productIdData);
                  }
                }, child: Text("Purchase Prodcut 1")),
                ElevatedButton(onPressed: () async {
                  if (Platform.isIOS) {
                    //check if alreadyPurchased
                    if (alreadyPurchased.contains(pro_ID)) {
                      //toast
                      await Fluttertoast.showToast(
                          msg: "You already purchased this product",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }

                    //check if product exist
                    var productExist = await checkProductExist(pro_ID);
                    if (!productExist) {
                      //toast
                      await Fluttertoast.showToast(
                          msg: "Product does not exist",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }

                    //make payment
                      iosPayment(pro_ID);
                    }
                }, child: Text("Purchase Prodcut 2") ),
                //product_33441
                ElevatedButton(onPressed: () async {
                  if (Platform.isIOS) {
                    //check if alreadyPurchased
                    if (alreadyPurchased.contains(productId3)) {
                      //toast
                      await Fluttertoast.showToast(
                          msg: "You already purchased this product",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }

                    //check if product exist
                    var productExist = await checkProductExist(productId3);
                    if (!productExist) {
                      //toast
                      await Fluttertoast.showToast(
                          msg: "Product does not exist",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }

                    //make payment
                      iosPayment(productId3);
                    }
                }, child: Text("Purchase Prodcut 3") ),
              ],
            ),
          ),
        ),
      );
  }


//makepayment ios
iosPayment(String pro_ID) async {
  try {
    print("Making payment");
    //toast
    await Fluttertoast.showToast(
        msg: "Making payment",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
    //make payment
    try {
      PurchaserInfo purchaserInfo =
          await Purchases.purchaseProduct(pro_ID);
      var originalAppUserId = purchaserInfo.originalAppUserId;
      var nonSubscriptionTransactions =
          purchaserInfo.nonSubscriptionTransactions;
      //revenueCatId
      dynamic transaction = nonSubscriptionTransactions[0];
      String revenueCatId = transaction.revenueCatId;
      //productId
      String productId = transaction.productId;
      //purchaseDate
      String purchaseDate = transaction.purchaseDate;
      //remove $ from $originalAppUserId
      originalAppUserId = originalAppUserId.replaceAll("\$", "");
      //remove RCAnonymousID: from originalAppUserId
      originalAppUserId = originalAppUserId.replaceAll("RCAnonymousID:", "");
      var userDDD = {
        "user_id": "$originalAppUserId",
      };
      //productAdded
      var productAdded = {
        "product_id": "$productId",
        "revenueCatId": "$revenueCatId",
        "purchaseDate": "$purchaseDate",
        "originalAppUserId": "$originalAppUserId",
      };
      //save product data to server
      var userdata = {
        "originalAppUserId": "$originalAppUserId",
        "id": "0",
        "revenueCatId": "$revenueCatId",
        "productId": "$productId",
        "purchaseDate": "$purchaseDate"
      };
      //you can save to your server here
      //success toast
      await Fluttertoast.showToast(
          msg: "Purchase successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      //reload the user purchased product data
      await initPlatformState();
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        //toast
        await Fluttertoast.showToast(
            msg: "Purchase cancelled",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        //toast
        await Fluttertoast.showToast(
            msg: "Purchase not allowed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        //toast
        await Fluttertoast.showToast(
            msg: "Purchase failed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  } catch (e) {
    print(e);
    //toast
    await Fluttertoast.showToast(
        msg: "Purchase failed, try again",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
}
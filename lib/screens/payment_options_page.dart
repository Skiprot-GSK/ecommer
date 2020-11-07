import 'package:flutter/material.dart';

class PaymentOptions extends StatefulWidget {
  @override
  _PaymentOptions createState() => _PaymentOptions();
}

class _PaymentOptions extends State<PaymentOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Options'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}

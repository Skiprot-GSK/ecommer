import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPage createState() => _FAQPage();
}

class _FAQPage extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'FAQs from other users',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  'Can\'t find what your looking for please send us an email at : delgroce@gmail.com'),
            ),
          ],
        ),
      ),
    );
  }
}

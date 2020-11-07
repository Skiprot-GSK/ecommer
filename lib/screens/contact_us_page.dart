import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUs createState() => _ContactUs();
}

class _ContactUs extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.email),
                  title: Text(
                    "Email us",
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                  subtitle: Text(
                    "delgroce@gmail.com",
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Container(
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(
                    "You can call us",
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                  subtitle: Text(
                    "+27 72 667 5942",
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Container(
              child: Card(
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.globe),
                  title: Text(
                    "Reach us",
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                  subtitle: Text(
                    "www.delgroce.com",
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Container(
              child: Card(
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.globe),
                  title: Text(
                    "Help",
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                  subtitle: Text(
                    "www.delgroce.com/help",
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

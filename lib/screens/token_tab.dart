import 'package:flutter/material.dart';
import 'package:plumber_app/components/color.dart';
import 'package:plumber_app/screens/token_details_page.dart';
import 'package:plumber_app/screens/tokens_history.dart';

class TokenTabPages extends StatefulWidget {
  @override
  _TokenTabPagesState createState() => _TokenTabPagesState();
}

class _TokenTabPagesState extends State<TokenTabPages> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            'টোকেনের হিসাব',
            style: TextStyle(color: stella_red),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(indicatorColor: stella_red, tabs: [
            Tab(
              child: Text(
                'সকল টোকেনের হিসাব',
                style: TextStyle(color: stella_red),
              ),
            ),
            Tab(
              child: Text(
                'টোকেনের ইতিহাস',
                style: TextStyle(color: stella_red),
              ),
            ),
          ]),
        ),
        body: SafeArea(
            child: Container(
                child: TabBarView(
                    children: [TokenDetailsPgae(), TokenHistory()]))),
      ),
    );
  }
}

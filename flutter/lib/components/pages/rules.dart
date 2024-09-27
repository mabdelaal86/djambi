import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class RulesPage extends StatefulWidget {
  @override
  _RulesPageState createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  late final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages;
  bool isReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rules"),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: 'assets/rules/Djambi_rules.pdf',
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onPageChanged: (int? page, int? total) {
              if (kDebugMode) {
                print('page change: $page/$total');
              }
            },
          ),
          !isReady
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage(),
        ],
      ),
    );
  }
}

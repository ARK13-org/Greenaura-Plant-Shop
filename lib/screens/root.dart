import 'package:flutter/material.dart';
import 'package:pant_app/const/constant.dart';

class RootPage extends StatefulWidget {
  const new({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Root Page'),
        backgroundColor: Constant.background,
      ),
    );
  }
}

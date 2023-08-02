import 'package:flutter/material.dart';

class CrashScreen extends StatelessWidget {
  const CrashScreen({Key? key}) : super(key: key);
  static const routeName = "/crash";

  @override
  Widget build(BuildContext context) {
    return const FittedBox(child: Text("404"));
  }
}

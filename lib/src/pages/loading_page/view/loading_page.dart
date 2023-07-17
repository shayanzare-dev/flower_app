import 'package:flutter/material.dart';

import 'widget/loading_widget.dart';

class LoadingPage extends StatelessWidget {
   const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      backgroundColor: Color(0xff54786c),
      bottomNavigationBar:  LoadingWidget(),
    );
  }
}

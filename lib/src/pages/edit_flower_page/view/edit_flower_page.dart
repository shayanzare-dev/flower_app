import 'package:flower_app/src/pages/edit_flower_page/view/widget/edit_flower_page.dart';
import 'package:flutter/material.dart';

class EditFlowerPage extends StatelessWidget {
  const EditFlowerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: const Text('Edit Flower page'),
          backgroundColor: const Color(0xff04927c)),
      body:  EditFlowerPageForm(),
    );
}

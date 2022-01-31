import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile page'),
      ),
      body: const Text('Profile page').center(),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Unknown',
        child: const Icon(Icons.add),
      ),
      */
    );
  }
}

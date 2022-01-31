import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:auto_route/auto_route.dart';

final logger = Logger(
  printer: PrettyPrinter(methodCount: 0, lineLength: 140),
);

Future<void> saveToDB(Map<String, dynamic> mix) {
  return FirebaseFirestore.instance.collection('/last/').doc(mix['uid']).set(mix, SetOptions(merge: true));
}

Future<void> showErrorMessage(BuildContext context, Exception? exception) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.white54,
    builder: (context) {
      return AlertDialog(
        title: const Text('Ошибка!'),
        content: Text(exception.toString()).textColor(Theme.of(context).errorColor),
        actions: [
          TextButton(
            child: const Text('ПОНЯЛ'),
            onPressed: () {
              context.router.pop();
            },
          ),
        ],
      );
    },
  );
}

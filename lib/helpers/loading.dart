import 'package:flutter/material.dart';

extension Loading on BuildContext {
  void showLoadingDialog() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void hideLoadingDialog() {
    Navigator.of(this).pop();
  }
}

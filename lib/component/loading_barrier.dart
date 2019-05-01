import 'package:flutter/material.dart';

class LoadingBarrier extends StatelessWidget {
  final bool isLoading;

  LoadingBarrier(this.isLoading);

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {
      return Stack(children: <Widget>[
        Opacity(
          opacity: 0.3,
          child: const ModalBarrier(
            dismissible: false,
            color: Colors.black,
          ),
        ),
        Center(child: CircularProgressIndicator())
      ]);
    } else {
      return SizedBox.shrink();
    }
  }
}
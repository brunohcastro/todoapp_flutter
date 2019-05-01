import 'package:flutter/material.dart';

class LoadingBarrier extends StatelessWidget {
  final bool isLoading;

  LoadingBarrier(this.isLoading);

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {
      return Stack(children: <Widget>[
        const Opacity(
          opacity: 0.3,
          child: ModalBarrier(
            dismissible: false,
            color: Colors.black,
          ),
        ),
        const Center(child: CircularProgressIndicator())
      ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}

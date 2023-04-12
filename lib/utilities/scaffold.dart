import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({Key? key, required this.child, required this.loading, this.resizeToAvoidBottomInset})
      : super(key: key);

  final Widget child;
  final ValueNotifier<bool> loading;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Stack(
        children: [
          child,
          ValueListenableBuilder(
            valueListenable: loading,
            builder: (BuildContext context, bool loading, Widget? child) =>
                Visibility(
              visible: loading,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.4),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

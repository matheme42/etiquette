import 'package:flutter/material.dart';

class DatabaseViewBody extends StatelessWidget {
  final List<Widget> children;

  const DatabaseViewBody({super.key, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.black),
            ),
            child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 1,
                child: Center(
                    child: Column(
                        mainAxisSize: MainAxisSize.min, children: children)))));
  }
}

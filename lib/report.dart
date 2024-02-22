import 'package:flutter/material.dart';

class Report extends StatelessWidget {
  const Report({super.key});

  static List<String> messages = [];

  static showReport(BuildContext context) {
    showDialog(context: context, builder: (context) => const Report());
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 400) {
      return const SizedBox.shrink();
    }
    return Center(
      child: FractionallySizedBox(
        heightFactor: 0.8,
        child: SizedBox(
          width: 400,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.black87, width: 1.5)),
            child: Column(
              children: [
                const SizedBox(
                    height: 60,
                    child: Text("Rapport d'importations",
                        textScaler: TextScaler.linear(2))),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: messages.length,
                        itemExtent: 120,
                        itemBuilder: (context, index) {
                          List<String> texts = messages[index].split("\$");
                          return Container(
                            margin: const EdgeInsets.all(4.0),
                            padding: const EdgeInsets.only(left: 4.0),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                border: Border.all(color: Colors.black87)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(texts[0],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(width: 60, child: Divider()),
                                SelectableText(texts[1]),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

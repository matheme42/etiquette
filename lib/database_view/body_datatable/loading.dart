import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingDataTable extends StatelessWidget {
  const LoadingDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Builder(builder: (context) {
            if (MediaQuery.of(context).size.height < 100) {
              return const SizedBox.shrink();
            }
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 4),
              child: AutoSizeText('Chargement des données',
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            );
          }),
          Builder(builder: (context) {
            if (MediaQuery.of(context).size.height < 150) {
              return const SizedBox.shrink();
            }
            return LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white, size: 80);
          })
        ],
      ),
    );
  }
}

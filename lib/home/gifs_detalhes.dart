import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class GifDetalhes extends StatelessWidget {
  const GifDetalhes({super.key, required this.data});
  final Map data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data["title"]),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () async {
                await FlutterShare.share(
                    title: data["title"],
                    text: 'TESTE DE APP   ',
                    linkUrl: data["images"]["fixed_height"]["url"],
                    chooserTitle: data["title"]);
              },
              icon: const Icon(Icons.share))
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(data["images"]["fixed_height"]["url"]),
      ),
    );
  }
}

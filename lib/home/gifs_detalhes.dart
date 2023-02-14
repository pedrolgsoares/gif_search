import 'package:flutter/material.dart';

class GifDetalhes extends StatelessWidget {
  const GifDetalhes({super.key, required this.data});
  final Map data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data["title"]),
        backgroundColor: Colors.black,
        actions: const [Icon(Icons.share)],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(data["images"]["fixed_height"]["url"]),
      ),
    );
  }
}

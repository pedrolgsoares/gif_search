import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:gif_search/home/gifs_detalhes.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? pesquisa;
  int offset = 0;

  Future<Map> getGifs() async {
    http.Response response;
    if (pesquisa == null) {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=wusbFwUExpkztfjeMr3QRimPUc4kd1J9&limit=20&rating=G"));
    } else {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=wusbFwUExpkztfjeMr3QRimPUc4kd1J9&q=$pesquisa&limit=20&offset=$offset&rating=G&lang=en"));
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    getGifs().then((map) {
      if (kDebugMode) {
        print(map);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                  labelText: "Pesquise aqui",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (String str) {
                setState(() {
                  pesquisa = str;
                  offset = 0;
                });
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: getGifs(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        );
                      case ConnectionState.none:
                        return const Center(
                          child: Text(
                            'VAZIO',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      default:
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("ERRO NA REQUISIÇÃO",
                                style: TextStyle(color: Colors.red)),
                          );
                        } else {
                          return myWidget(context, snapshot);
                        }
                    }
                  }))
        ],
      ),
    );
  }

  int getTamanhoPesquisa(List tamanho) {
    if (pesquisa == null || pesquisa!.isEmpty) {
      return tamanho.length;
    } else {
      return tamanho.length + 1;
    }
  }

  Widget myWidget(BuildContext context, AsyncSnapshot snapshot) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
          itemCount: getTamanhoPesquisa(snapshot.data["data"]),
          itemBuilder: (BuildContext context, int index) {
            if (pesquisa == null || index < snapshot.data["data"].length) {
              return GestureDetector(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]
                      ["url"],
                  height: 300,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GifDetalhes(data: snapshot.data["data"][index])));
                },
                onLongPress: () async {
                  await FlutterShare.share(
                      title: snapshot.data["title"],
                      text: 'TESTE DE APP',
                      linkUrl: snapshot.data["images"]["fixed_height"]["url"],
                      chooserTitle: snapshot.data["title"]);
                },
              );
            } else {
              return GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    offset += 20;
                  });
                },
              );
            }
          }),
    );
  }
}

import 'package:chord_radar_nepal/helpers/db_helper.dart';
import 'package:chord_radar_nepal/model/songs_model.dart';
import 'package:chord_radar_nepal/pages/songchord_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<SongsModel> result = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      loading = true;
      final data = await DBhelper().readDb();
      if(data.isNotEmpty){
        setState(() {
          result = data;
          loading = false;
        });
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error reading db")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chord Radar Nepal"),
      ),
      body: loading 
        ? const Center(
          child: CircularProgressIndicator(),
        ) 
        : SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SongchordPage(song: result[index]),
                        )
                      );
                    },
                    title: Text(result[index].title.toString()),
                    subtitle: Text(result[index].singer.toString()),
                  );
                },
              )
            ],
          ),
        ),
    );
  }
}
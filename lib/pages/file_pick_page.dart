import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

class FilePickPage extends StatelessWidget {
  final Directory rootDirectory;
  Future<List<FileSystemEntity>> get files {
    return rootDirectory
        .list()
        .where((element) => p.extension(element.path) == '.db')
        .toList();
  }

  const FilePickPage({Key? key, required this.rootDirectory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a file'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
      future: files,
      builder: (BuildContext context,
          AsyncSnapshot<List<FileSystemEntity>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final file = snapshot.data![index];
              final fileName = p.basenameWithoutExtension(file.path);
              return ListTile(
                title: Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 24,
                    ),
                    child: Text(fileName),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, file.path);
                },
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

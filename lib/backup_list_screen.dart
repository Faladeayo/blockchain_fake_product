import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class BackupListScreen extends StatelessWidget {
  final String backupFolderPath;

  BackupListScreen({required this.backupFolderPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backed-up Files'),
      ),
      body: FutureBuilder<List<FileSystemEntity>>(
        future: _getBackupFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No backed-up files found.'));
          } else {
            final backupFiles = snapshot.data!;
            return ListView.builder(
              itemCount: backupFiles.length,
              itemBuilder: (context, index) {
                final file = backupFiles[index];
                return ListTile(
                  title: Text(file.path.split('/').last),
                  onTap: () {
                    OpenFile.open(file.path);
                    // Perform action on file tap
                    print(file.path);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => PDFViewScreen(
                    //               filePath: file.path,
                    //             )));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<FileSystemEntity>> _getBackupFiles() async {
    final directory = Directory(backupFolderPath);
    final backupFiles = directory.listSync(recursive: false);
    return backupFiles;
  }
}

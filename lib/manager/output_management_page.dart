import 'package:facial_emotions/manager/statistics_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/myobject.dart';
import '../utils/object_box_manager.dart';


class ObjectBoxQueryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final objectBoxManager = Provider.of<ObjectBoxManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ObjectBox Query Page'),
      ),
      body: FutureBuilder<List<MyObject>>(
        future: objectBoxManager.getAllMyObjectData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final obj = snapshot.data![index];
                return ListTile(
                  title: Text('Video: ${obj.videoName}'),
                  subtitle: Text('Time: ${obj.datetime}'),
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => StatisticsDetailPage(object: obj)));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

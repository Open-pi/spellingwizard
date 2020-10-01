import 'package:flutter/material.dart';

class ToolsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tools'),
          centerTitle: true,
          backgroundColor: Colors.grey[850],
        ),
        body: _toolsListView());
  }

  ListView _toolsListView() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text('Lesson number $index'),
          subtitle: Text('Put Small Description Here'),
          leading: starsIcons(),
          trailing: Icon(Icons.arrow_forward),
        );
      },
    );
  }
}

Container starsIcons() {
  return Container(
    width: 50,
    child: Row(
      children: <Icon>[
        Icon(
          Icons.star,
          size: 15,
        ),
        Icon(
          Icons.star,
          size: 20,
        ),
        Icon(
          Icons.star,
          size: 15,
        )
      ],
    ),
  );
}

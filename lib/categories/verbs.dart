import 'package:flutter/material.dart';

class VerbsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verbs'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: _verbsListView(),
    );
  }

  ListView _verbsListView() {
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

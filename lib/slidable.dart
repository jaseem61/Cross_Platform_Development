import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';

class Slide extends StatelessWidget {
  final Function delete;
  final Function done;
  final String title;
  final int page;
  Slide({this.title, this.delete, this.done, this.page});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Container(
        child: ListTile(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: page == 0 ? 0.25 : 0.35,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete_forever,
          onTap: delete,
        )
      ],
      secondaryActions: page == 0
          ? <Widget>[
              IconSlideAction(
                caption: 'Done',
                color: Colors.green,
                icon: Icons.done,
                onTap: done,
              )
            ]
          : null,
    );
  }
}

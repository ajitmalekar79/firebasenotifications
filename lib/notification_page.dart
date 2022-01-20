import 'index.dart';

class NotificationView extends StatefulWidget {
  var data;
  NotificationView({Key key, this.data}) : super(key: key);

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification View"),
      ),
      body: Center(
        child: Text(
          "Content = ${widget.data['body']}",
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}

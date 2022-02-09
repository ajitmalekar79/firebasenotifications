import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class StoreDataFirebase extends StatefulWidget {
  const StoreDataFirebase({Key key}) : super(key: key);

  @override
  _StoreDataFirebaseState createState() => _StoreDataFirebaseState();
}

class _StoreDataFirebaseState extends State<StoreDataFirebase> {
  final textcontroller = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref();
  final Future<FirebaseApp> _future = Firebase.initializeApp();

  Future<void> addData(String data) async {
    if (databaseRef != null) {
      print("Database Exists");
      await databaseRef.push().set({'name': data, 'comment': 'A good season'});
      print("Operation Donr");
      // .then((value) => print("Data Added"), onError: (e){
      //   print("Error is==$e");
      // });
    } else {
      print("Database Need to be create");
    }
  }

  void printFirebase() {
      // databaseRef.get()
    databaseRef.once().then((snapshot) {
      print('Data : ${snapshot.snapshot.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Demo"),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 250.0),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: textcontroller,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Center(
                        child: RaisedButton(
                            color: Colors.pinkAccent,
                            child: Text("Save to Database"),
                            onPressed: () {
                              addData(textcontroller.text);
                              //call method flutter upload
                            })),
                    Center(
                        child: RaisedButton(
                            color: Colors.pinkAccent,
                            child: Text("Read Database"),
                            onPressed: () {
                              printFirebase();
                              //call method flutter upload
                            })),
                  ],
                ),
              );
            }
          }),
    );
  }
}

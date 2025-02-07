import 'package:flutter/material.dart';
import 'package:myproject/data/dbHelper.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  var title = TextEditingController();
  var description = TextEditingController();
  DBHelper? DbRef;

  List<Map<String, dynamic>> allNotes = [];

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  void getNotes() async {
    DbRef = DBHelper.getInstance;
    List<Map<String, dynamic>> result = await DbRef!.fetchNotes();
    setState(() {
      allNotes = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My App"),
        backgroundColor: Colors.amber,
      ),
      body: Center(
          child: allNotes.isNotEmpty
              ? ListView.builder(
                  itemCount: allNotes.length,
                  itemBuilder: (_, ind) {
                    return InkWell(
                      onTap: () {
                        title.text = allNotes[ind][DBHelper.TABLE_NOTE['name']];
                        description.text =
                            allNotes[ind][DBHelper.TABLE_NOTE['description']];
                        getBottomModalSheetView(
                            isUpdate: true,
                            id: allNotes[ind][DBHelper.TABLE_NOTE['id']]);
                      },
                      child: ListTile(
                        leading: Text(
                          '${ind + 1}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        title: Text(
                            '${allNotes[ind]['${DBHelper.TABLE_NOTE['name']}']}'),
                        subtitle: Text(
                            '${allNotes[ind]['${DBHelper.TABLE_NOTE['description']}']}'),
                        trailing: Container(
                            width: 50,
                            child: CircleAvatar(
                              child: Center(
                                child: IconButton(
                                    onPressed: () async {
                                      DbRef = DBHelper.getInstance;
                                      await DbRef!.deleteNote(allNotes[ind]
                                          [DBHelper.TABLE_NOTE['id']]);
                                      getNotes();
                                    },
                                    icon: Icon(Icons.delete)),
                              ),
                            )),
                      ),
                    );
                  })
              : Text("no notes")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          title.clear();
          description.clear();
          getBottomModalSheetView();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future getBottomModalSheetView({bool isUpdate = false, int id = 0}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(14),
            height: 400,
            width: double.infinity,
            child: Column(
              spacing: 8,
              children: [
                Text(
                  isUpdate ? "Update Note" : "Add Note",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                      hintText: "Enter Title",
                      labelText: isUpdate ? title.text : "title",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.orange, width: 1))),
                ),
                TextField(
                  controller: description,
                  decoration: InputDecoration(
                      hintText: "Enter Description",
                      labelText: isUpdate ? description.text : "description",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.orange, width: 1))),
                ),
                ElevatedButton(
                    onPressed: () async {
                      DbRef = DBHelper.getInstance;
                      isUpdate
                          ? await DbRef!
                              .editNote(id, title.text, description.text)
                          : await DbRef!.addNote(title.text.toString(),
                              description.text.toString());
                      getNotes();
                      Navigator.pop(context);
                    },
                    child: Text(isUpdate ? "Edit" : "Submit"))
              ],
            ),
          );
        });
  }
}

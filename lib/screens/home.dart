import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_pad/models/note.dart';
import 'package:note_pad/screens/notes/note_form.dart';
import 'package:note_pad/theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    List<Note>? noteBox = Hive.box('notes')
            .get('notes')
            ?.map((e) => Note.fromJson(e))
            .toList()
            ?.cast<Note>() ??
        [];
    Icon icon(bool isPinned) {
      return Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          ElevatedButton(
            onPressed: () {
              context.push('/notes');
            },
            child: Text('Notes Category'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        HomeService()
                            .searchNote(noteBox, searchController.text);
                        isLoading = false;
                      });
                    },
                    child: Text('Search'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: noteBox?.length ?? 0,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      noteBox?[index].title ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      noteBox?[index].createdAt ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return NoteFormScreen(
                                    note: noteBox?[index], index: index);
                              })).then((value) => setState(() {}));
                            },
                            child: Icon(Icons.edit)),
                        ElevatedButton(
                          onPressed: () async {
                            HomeService().pinnedNote(noteBox, index);
                            setState(() {});
                          },
                          child: icon(noteBox?[index].isPinned ?? false),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Delete Note'),
                                  content:
                                      Text('Are you sure to delete this note?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        HomeService().deleteAt(index);
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                            setState(() {});
                          },
                          child: Icon(
                            Icons.delete_outline,
                            color: LightTheme.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add').then((value) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class HomeService {
  pinnedNote(note, int indexOf) async {
    List<Note> note = [];
    var box = Hive.box('notes');
    var data = await box.get('notes');
    if (data != null) {
      // log(data.toString());
      note = List<Note>.from(
        data.map(
          (item) => Note.fromJson(item),
        ),
      );
      note[indexOf].isPinned = !(note[indexOf].isPinned ?? false);
      var back = note.map((e) => e.toJson()).toList();
      // log(back.toString());
      await box.put('notes', back);
    }
  }

  deleteAt(index) async {
    List<Note> note = [];
    var box = Hive.box('notes');
    var data = await box.get('notes');
    if (data != null) {
      // log(data.toString());
      note = List<Note>.from(
        data.map(
          (item) => Note.fromJson(item),
        ),
      );
      note.removeAt(index);
      var back = note.map((e) => e.toJson()).toList();
      // log(back.toString());
      await box.put('notes', back);
    }
  }

  void searchNote(List<Note>? noteBox, String? text) {
    List<Note> note = [];
    var box = Hive.box('notes');
    var data = box.get('notes');
    if (data != null) {
      // log(data.toString());
      note = List<Note>.from(
        data.map(
          (item) => Note.fromJson(item),
        ),
      );
      note = note
          .where((element) =>
              element.title!.toLowerCase().contains(text!.toLowerCase()))
          .toList();
      box.put('notes', note.map((e) => e.toJson()).toList());
    }
  }

  getData() async {
    List<Note> note = [];
    var box = Hive.box('notes');
    var data = box.get('notes');
    if (data != null) {
      // log(data.toString());
      note = List<Note>.from(
        data.map(
          (item) => Note.fromJson(item),
        ),
      );
    }
    return note;
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_pad/models/category.dart';
import 'package:note_pad/screens/notes/category_form.dart';
import 'package:note_pad/theme.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({
    super.key,
  });

  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  @override
  Widget build(BuildContext context) {
    List<Category>? categoryBox = Hive.box('note_categories')
            .get('note_categories')
            ?.map((e) => Category.fromJson(e))
            .toList()
            ?.cast<Category>() ??
        [];
    print(categoryBox);
    return Scaffold(
        appBar: AppBar(
          title: Text('Note Categories'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: categoryBox?.length ?? 0,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categoryBox?[index].name ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return CategoryFormScreen(
                                category: categoryBox?[index], index: index);
                          })).then((value) => setState(() {}));
                        },
                        child: Icon(Icons.edit)),
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
                                    CategoryService().deleteAt(index);
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/add_category').then((value) => setState(() {}));
          },
          child: Icon(Icons.add),
        ));
  }
}

class CategoryService {
  deleteAt(index) async {
    List<Category> note = [];
    var box = Hive.box('notes');
    var data = await box.get('notes');
    if (data != null) {
      // log(data.toString());
      note = List<Category>.from(
        data.map(
          (item) => Category.fromJson(item),
        ),
      );
      note.removeAt(index);
      var back = note.map((e) => e.toJson()).toList();
      // log(back.toString());
      await box.put('notes', back);
    }
  }
}

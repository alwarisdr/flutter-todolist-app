import 'package:flutter/material.dart';
import 'package:todolistapp/constants/colors.dart';
import 'package:todolistapp/model/todo.dart';
import 'package:todolistapp/widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {

  final todoList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todoList;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todoList;
    } else {
      results = todoList
        .where((todo) => todo.todoText!
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
        .toList();
    }
    
    setState(() {
      _foundToDo = results;
    });
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }
  
  void _deleteToDoItem (String id) {
    todoList.removeWhere((item) => item.id == id);
    setState(() {
    });
  }

  void _addTodoItem(String toDo) {
    todoList.add(ToDo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      todoText: toDo,
    ));
    setState(() {
      _todoController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tdBGColor,
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.menu,
              color: tdBlack,
              size: 30,
            ),
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(Icons.search, color: tdGrey, size: 20,),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 20,
                        minHeight: 25,
                      ),
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: tdGrey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 50,
                          bottom: 20, 
                        ),
                        child: Text(
                          'All ToDos',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      //Show ToDo Items
                      for(ToDo todoo in _foundToDo.reversed)
                        ToDoItem(
                          todo:todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        )
                    ],
                  )
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 20,
                      bottom: 20,
                      right: 10,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical : 5
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow:const[
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 0.0,
                          blurRadius: 10.0,
                          offset: Offset(0.0,0.0)
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'Add a new todo item',
                        border: InputBorder.none,
                      ),
                    ),
                ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      _addTodoItem(_todoController.text);
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                    child: Text(
                      '+',
                      style: TextStyle(fontSize: 40,color: Colors.white,),
                    ),
                  ),
                ),
              ],
            )
          )

        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  

}



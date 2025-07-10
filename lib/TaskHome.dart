import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:origi/attraclogi.dart';
import 'package:origi/config.dart';

class Taskhome extends StatefulWidget {
  final String token;


  const Taskhome({required this.token, Key? key}) : super(key: key);

  @override
  State<Taskhome> createState() => _TaskhomeState();
}

class _TaskhomeState extends State<Taskhome> {
  List<Map<String, String>> tasks = [];
  late String userId;
  late String objId;



  final TextEditingController _taskname = TextEditingController();
  final TextEditingController _taskdesc = TextEditingController();

  @override
  void initState() {
    super.initState();
    final decoded = JwtDecoder.decode(widget.token);
    objId = decoded['id'];
    userId = decoded['userId'];


    _fetchTasks(); // fetch tasks when screen loads
  }
  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ALoginPage()),
    );
  }
  Widget _buildStatusWithIcon(String status) {
    IconData icon;
    Color color;

    switch (status.toLowerCase()) {
      case 'completed':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'pending':
        icon = Icons.schedule;
        color = Colors.orange;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          status[0].toUpperCase() + status.substring(1),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> _fetchTasks() async {
    try {
      final response = await http.get(
        Uri.parse('$fetchTask?userId=$objId'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonTasks = jsonDecode(response.body);
        setState(() {
          tasks = jsonTasks.map<Map<String, String>>((task) {
            return {
              'id': task['_id'],
              'name': task['title'] ?? '',
              'description': task['description'] ?? '',
              'status': task['status'] ?? 'pending',
              'date': task['date'],
            };
          }).toList();
        });
      } else {
        print('Failed to fetch tasks: ${response.body}');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }
  Future<void> _markTaskAsCompleted(String taskId) async {
    final response = await http.put(
      Uri.parse(updateTask),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      },
      body: jsonEncode({
        "id": taskId, // send it in body
        "status": "completed",
      }),
    );


    if (response.statusCode == 200) {
      _fetchTasks();
    } else {
      print('Failed to update task: ${response.body}');
    }
  }
  void _popup2(String taskId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Have you completed your task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _markTaskAsCompleted(taskId);

              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _popup() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add your Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _taskname,
                decoration: const InputDecoration(
                  labelText: 'Task name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _taskdesc,
                decoration: const InputDecoration(
                  labelText: 'Task description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_taskname.text.isNotEmpty && _taskdesc.text.isNotEmpty) {
                  _addTaskToBackend();
                }
              },
              child: const Text("Add Task"),
            ),
          ],
        );
      },
    );
  }

  void _addTaskToBackend() async {
    final regBody = {
      "userId": objId,
      "title": _taskname.text,
      "description": _taskdesc.text,
      "status": 'pending',
    };

    final response = await http.post(
      Uri.parse(createTask),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      },
      body: jsonEncode(regBody),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Task created');
      _taskname.clear();
      _taskdesc.clear();
      Navigator.pop(context); // close dialog
      _fetchTasks(); // reload task list
    } else {
      print('Failed to create task: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
            margin: const EdgeInsets.only(top: 60.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Hello $userId',
                  style: const TextStyle(fontSize: 30.0, color: Colors.white,),
                ),
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ],
            ),

          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical:5.0),

            child:Text('Tap to update the status of your task',
            style: TextStyle(fontSize: 20.0, color: Colors.white,),),

          ),


          Expanded(
            child: tasks.isEmpty
                ? const Center(
              child: Text(
                'No tasks yet.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final bool isCompleted = (task['status']?.toLowerCase() == 'completed');
                final Color cardColor = isCompleted ? Colors.green[100]! : Colors.white;

                return Card(
                  color: cardColor,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: ListTile(
                    onTap: () {
                      if (task['status'] != 'completed') {
                        _popup2(task['id']!);
                      }
                    },
                    title: Text(task['name'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task['description'] ?? '', style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text('Created on: ${task['date'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: _buildStatusWithIcon(task['status'] ?? 'pending'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _popup,
        child: const Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}

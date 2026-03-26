import 'package:flutter/material.dart';
import 'package:flutter_task_v1_app/models/task.dart';
import 'package:flutter_task_v1_app/services/supabase_service.dart';
import 'package:flutter_task_v1_app/views/add_task_ui.dart';

class ShowAllTaskUi extends StatefulWidget {
  const ShowAllTaskUi({super.key});

  @override
  State<ShowAllTaskUi> createState() => _ShowAllTaskUiState();
}

class _ShowAllTaskUiState extends State<ShowAllTaskUi> {
  // สร้าง instance/ตัวแทน/object ของ SupabaseService
  final service = SupabaseService();

  // สร้างตัวแปรเพื่อเก็บข้อมูลที่ได้จากการดึงข้อมูลจาก Supabase
  List<Task> tasks = [];

  // สร้างเมธอดเพื่อเรียกใช้งาน service ดึงข้อมูลมาเก็บในตัวแปร
  void loadTasks() async {
    final data = await service.getTasks();
    setState(() {
      tasks = data;
    });
  }

  @override
  initState() {
    super.initState();
    // เรียกใช้งานเมธอดเพื่อดึงข้อมูล ตอนหน้าจอถูกเปิดขึ้นมา
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // ส่วนของ Appbar
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Task Krub V1',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        // ส่วนของปุ่มเปิดไปหน้าเพิ่ม task
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskUi(),
              ),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        //ส่วนของตำแหน่งของปุ่มเปิดไปหน้าเพิ่ม task
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        //ส่วนของ body ที่แสดงโลโก้และข้อมูลที่ดึงจาก supabase
        body: Center(
          child: Column(
            children: [
              // แสดง logo
              SizedBox(height: 40),
              Image.asset(
                'assets/images/logo.png',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              // ส่วนของ ListView ที่แสดงข้อมูลที่ดึงจาก Supabase
              Expanded(
                child: ListView.builder(
                    // จำนวนรายการ
                    itemCount: tasks.length,
                    // หน้าตาของแต่ละรายการ
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 35,
                          right: 35,
                        ),
                        child: ListTile(
                          onTap: () {},
                          leading: (tasks[index].task_image_url != null &&
                                  tasks[index].task_image_url != "")
                              ? Image.network(
                                  tasks[index].task_image_url!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/logo.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                          title: Text(
                            'งาน: ${tasks[index].task_name}',
                          ),
                          subtitle: Text(
                            'สถานะ: ${tasks[index].task_status == true ? 'เสร็จ' : 'ยังไม่เสร็จ'}',
                          ),
                          trailing: Icon(
                            Icons.info,
                            color: Colors.red,
                          ),
                          tileColor: index % 2 == 0 ? Colors.pink[50] : Colors.green[100],
                          contentPadding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}

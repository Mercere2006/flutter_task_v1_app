// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_task_v1_app/models/task.dart';
import 'package:flutter_task_v1_app/services/supabase_service.dart';

class AddTaskUi extends StatefulWidget {
  const AddTaskUi({super.key});

  @override
  State<AddTaskUi> createState() => _AddTaskUiState();
}

class _AddTaskUiState extends State<AddTaskUi> {
  // สร้างตัวควบคุม TextField และตัวแปรที่จะต้องเก็บข้อมูลที่ผู้ใช้ป้อนหรือเลือก เพื่อบันทึกใน task_tb
  TextEditingController taskNameCtrl = TextEditingController();
  TextEditingController taskWhereCtrl = TextEditingController();
  TextEditingController taskPersonCtrl = TextEditingController();
  bool taskStatus = false;
  TextEditingController taskDuedateCtrl = TextEditingController();
  String? taskImageUrl = '';

  //ตัวแปรเก็บไฟล์ที่ใช้อัปโหลดไปยัง task_bk
  File? file;

  //---- เปิดกลองถ่ายภาพ และกำหนดค่ารูปเพื่อ upload ----
  Future<void> pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.camera); //.gallery

    if (picked != null) {
      setState(() {
        file = File(picked.path);
      });
    }
  }
  //-----------------------------------------------

  //---- เปิดปฏิทันเลือกวันที่ และกำหนดค่าวันที่ ----
  DateTime? selectedDate;

  Future<void> pickDate() async {
    //เปิดปฏิทิน
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    //เอาค่าวันที่เลือกจากปฏิทินไปกำหนดให้กับ taskDuedateCtrl
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        taskDuedateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  //-------------------------

  //---- เมธอดอัปโหลดไฟล์ และบันทึกข้อมูลจากการกดปุ่มบันทึก ----
  Future<void> save() async {
    // Validate UI ว่าผู้ใช้งานป้อนหรือเลือกข้อมูลครบถ้วนหรือยัง ถ้ายังแสดงข้อความแจ้ง
    if (taskNameCtrl.text.isEmpty ||
        taskWhereCtrl.text.isEmpty ||
        taskPersonCtrl.text.isEmpty ||
        taskDuedateCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณาป้อนข้อมูลให้ครบถ้วน'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );

      return; //*** อย่าลืม return เพื่อไม่ให้ทำงานต่อ หรือ ให้ออกจากการทำงานของเมธอดนี้เลย
    }

    // สร้าง instance/object/ตัวแทน ของ SupabaseService เพื่อใช้งานเมธอดต่างๆ ที่สร้างไว้ใน SupabaseService
    final service = SupabaseService();

    // ตรวจสอบว่ามีการถ่าย/เลือกรูปหรือไม่ ถ้ามีก็อัปโหลดไฟล์ ไปที่ task_bk
    // แล้วเอา URL ของไฟล์ที่อัปโหลดเก็บในตัวแปรเพื่อใช้บันทึกใน task_tb
    if (file != null) {
      //หาก file ไม่เท่ากับ null แปลว่าได้มีการถ่าย/เลือกรูป
      //อัปโหลดไฟล์ไปยัง task_bk
      taskImageUrl = await service.uploadFile(file!);
    }

    // บันทึกข้อมูลลง task_tb
    // แพ็กข้อมูล
    final task = Task(
      task_name: taskNameCtrl.text,
      task_where: taskWhereCtrl.text,
      task_person: int.parse(taskPersonCtrl.text),
      task_status: taskStatus,
      task_duedate: taskDuedateCtrl.text,
      task_image_url: taskImageUrl,
    );
    // เรียกใช้เมธอด insertTask ที่สร้างไว้ใน SupabaseService เพื่อบันทึกข้อมูลลง task_tb
    await service.insertTask(task);

    // แจ้งผลการทำงาน (แสดงเป็น SnackBar หรือ AlertDialog ก็ได้)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกข้อมูลสำเร็จ'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // ย้อนกลับไปยังหน้าหลัก ShowAllTaskUi
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Task Na Ja V.1 (เพิ่ม)',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 30,
            left: 45,
            right: 45,
            bottom: 50,
          ),
          child: Center(
            child: Column(
              children: [
                // ส่วนแสดงรูปและรูปกล้องเพื่อเปิดกล้อง
                file == null
                    ? InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: Icon(
                          Icons.add_a_photo_rounded,
                          size: 150,
                          color: Colors.grey[300],
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: Image.file(
                          file!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                // ป้อนทำอะไร
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ทำอะไร',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: taskNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น ซักผ้า, ซ่อมหลอดไฟ',
                  ),
                ),
                SizedBox(height: 20),
                // ป้อนทำที่ไหน
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ทำที่ไหน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: taskWhereCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น บ้าน, ที่ทำงาน',
                  ),
                ),
                SizedBox(height: 20),
                // ป้อนทำกันกี่คน
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ทำกันกี่คน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: taskPersonCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น 2, 5',
                  ),
                ),
                SizedBox(height: 20),
                // เลือกทำเสร็จหรือยัง
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ทำเสร็จหรือยัง',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          taskStatus = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            taskStatus == true ? Colors.green : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.35,
                          50,
                        ),
                      ),
                      child: Text(
                        'เสร็จแล้ว',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          taskStatus = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            taskStatus == false ? Colors.green : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.35,
                          50,
                        ),
                      ),
                      child: Text(
                        'ยังไม่เสร็จ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // เลือกต้องเสร็จเมื่อไหร่
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'เสร็จเมื่อไหร่',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: taskDuedateCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น 2020-01-31',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () {
                    pickDate();
                  },
                ),
                SizedBox(height: 20),
                // ปุ่มบันทึก
                ElevatedButton(
                  onPressed: () {
                    //เรียกใช้เมธอด save เพื่ออัปโหลดไฟล์และบันทึกข้อมูล
                    save();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                  child: Text(
                    "บันทึก",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // ปุ่มยกเลิก
                ElevatedButton(
                  onPressed: () {
                    //เคลียหน้าจอ
                    setState(() {
                      taskNameCtrl.clear();
                      taskWhereCtrl.clear();
                      taskPersonCtrl.clear();
                      taskDuedateCtrl.clear();
                      file = null;
                      taskStatus = false;
                      taskImageUrl = '';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                  child: Text(
                    "ยกเลิก",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

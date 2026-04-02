// ไฟล์นี้ใช้สำหรับสร้างการทำงานต่าง ๆ กับ Supabase
// CRUD กับ Table -> Database (PostgreSQL) -> Supabase
// Upload/delete file กับ Bucket -> Storage -> Supabase

import 'dart:io';

import 'package:flutter_task_v1_app/models/task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // สร้าง instance/ตัวแทน ของ Supabase เพื่อใช้งาน
  final supabase = Supabase.instance.client;

  // สร้างคำสั่ง/เมธอดการทำงานต่าง ๆ กับ Supabase
  // เมธอดดึงข้อมูลงานทั้งหมดจาก task_tb และรีเทิร์นค่าที่ได้จากการดึงไปใช้งาน
  Future<List<Task>> getTasks() async {
    // ดึงข้อมูลงานทั้งหมดจาก task_tb
    final data = await supabase.from('task_tb').select('*');
    // รีเทิร์นค่าที่ได้จากการดึงไปใช้งาน
    return data.map((task) => Task.fromJson(task)).toList();
  }

  // เมธอดอัปโหลดไฟล์ไปยัง task_bk และ return ค่าข้อมูลที่ได้จากการอัปโหลดไปใช้งาน
  Future<String> uploadFile(File file) async {
    // สร้างชื่อไฟล์ใหม่ให้ไฟล์ เพื่อไม่ให้ชื่อไฟล์ซ้ำกัน
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}-${file.path.split('/').last}';

    // อัปโหลดไฟล์ไปยัง task_bk
    await supabase.storage.from('task_bk').upload(fileName, file);

    // return ค่าข้อมูลที่ได้จากการอัปโหลดไปใช้งาน
    return supabase.storage.from('task_bk').getPublicUrl(fileName);
  }

  // เมธอดเพิ่มข้อมูลไปยัง task_tb
  Future insertTask(Task task) async {
    await supabase.from('task_tb').insert(task.toJson());
  } 

  // เมธอดลบไฟล์ที่อัปโหลดไปยัง task_bk
  Future deleteFile(String fileName) async {
    // ลบไฟล์ที่อัปโหลดไปยัง task_bk
    // ก่อนลบให้ตัดเลือกแค่ชื่อไฟล์ ไม่เอาที่อยู่ไฟล์
    fileName = fileName.split('/').last;
    await supabase.storage.from('task_bk').remove([fileName]);
  }

  // เมธอดแก้ไขข้อมูลใน task_tb
    Future updateTask(String id, Task task) async {
    await supabase.from('task_tb').update(task.toJson()).eq('id', id);
  } 

  // เมธอดลบข้อมูลใน task_tb
    Future deleteTask(String id, Task task) async {
    await supabase.from('task_tb').delete().eq('id', id);
  } 
}

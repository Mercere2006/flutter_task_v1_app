// ไฟล์ที่สร้างขึนเพื่อแมปกับข้อมูลใน table ที่เราจะทำงานด้วย
class Task {
  // ตัวแปรที่แมปกับคอลัมน์ใน table
  String? id;
  String? task_name;
  String? task_where;
  int? task_person;
  bool? task_status;
  String? task_duedate;
  String? task_image_url;

  // สร้าง constructor เพื่อใช้ในการแพ็คข้อมูล
  Task({
    this.id,
    this.task_name,
    this.task_where,
    this.task_person,
    this.task_status,
    this.task_duedate,
    this.task_image_url,
  });

  // แปลงข้อมูลจาก Server/Cloud ซึ่งเป็น JSON มาเป็นข้อมูลี่จะใช้ในแอป
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        task_name: json['task_name'],
        task_where: json['task_where'],
        task_person: json['task_person'],
        task_status: json['task_status'],
        task_duedate: json['task_duedate'],
        task_image_url: json['task_image_url'],
      );

  // แปลงข้อมูลจากข้อมูลในแอปเป็น JSON มาเพื่อส่งไปยัง Server/Cloud (toJSON)
  Map<String, dynamic> toJson() => {
        'id': id,
        'task_name': task_name,
        'task_where': task_where,
        'task_person': task_person,
        'task_status': task_status,
        'task_duedate': task_duedate,
        'task_image_url': task_image_url,
      };
}

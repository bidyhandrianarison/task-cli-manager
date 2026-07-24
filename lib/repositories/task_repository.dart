class TaskRepository implements Repository<Task> {
  final File _file;
  final List<Task> _tasks = [];

  @override
  Future <void> load() async {
    _tasks.clear();
    if(_file.existsSync()) {
      final content = await _file.readAsString();
     try{
         List<dynamic> data = jsonDecode(content);

         for (final item in data){
           _tasks.add(Task.fromJson(item as Map<String, dynamic>));
         }
     }on FormatException{
       throw InvalidTaskException('Invalid JSON format');
     }
    }else{

    }
  }

  @override
  Future <void> save() async {
    final List<Map<String, dynamic>> jsonTasks = _tasks.map((task) => task.toJson()).toList();
    final content = jsonEncode(jsonTasks);
    await _file.writeAsString(content);
  }

  @override
  Future <void>clear(){}
  @override
  Future<List<Task>> findAll() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task> findById(int id) async {
    for (final task in _tasks) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  @override
  Future<void> add(Task task) async {
    _tasks.add(task);
    await _tasks.save();
  }

  @override
  Future<Task> update(Task task) async {
    
  }

  @override
  Future<void> delete(Task task) async {

  }

  @override
  void markAsDone(Task task) {

  }

  TaskRepository(this._file);

}

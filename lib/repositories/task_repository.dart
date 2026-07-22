class TaskRepository implements Repository<Task> {
  final File _file;
  final List<Task> _tasks;
  @override
  Future<List<Task>> findAll() async {
  }
  @override
  Future<Task> findById(int id) async {

  }

  @override
  Future<Task> add(Task task) async {

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

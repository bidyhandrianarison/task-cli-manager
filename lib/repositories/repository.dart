abstract interface class Repository<T> {
  Future<void> load();
  Future<List<T>> findAll();
  Future<T?> findById(int id);
  Future<void> add(T item);
  Future<void> update(T item);
  Future<void> delete(int id);
  Future<int> findIndexById(int id);
}

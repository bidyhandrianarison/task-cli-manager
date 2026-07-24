abstract interface class Repository<T> {
  Future<void> load();
  Future<void> save();
  Future <void> clear();
  Future<List<T>> findAll();
  Future<T?> findById(int id);
  Future<T?>find(T item);
  Future<void> add(T item);
  Future<void> update(T item);
  Future<void> delete(T item);
}

abstract interface class Repository<T> {
  Future<List<T>> findAll();
  Future<T?>find(T item);
  Future<void> add(T item);
  Future<void> update(T item);
  Future<void> delete(T item);
}

class CreateFailed implements Exception {
  final String message;
  CreateFailed(this.message);
}

class ReadFailed implements Exception {
  final String message;
  ReadFailed(this.message);
}

class UpdateFailed implements Exception {
  final String message;
  UpdateFailed(this.message);
}

class DeleteFailed implements Exception {
  final String message;
  DeleteFailed(this.message);
}

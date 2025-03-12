import 'storage_service.dart'; // Correct import

class AuthService {
  final StorageService _storageService; // Declare as a field

  AuthService() : _storageService = StorageService(); // Initialize in constructor

  Future<bool> verifyPin(String pin) async {
    final storedPin = await _storageService.loadPin();
    return storedPin == pin;
  }

  Future<bool> setPin(String pin) async {
    await _storageService.savePin(pin);
    return true;
  }

  Future<bool> hasPin() async {
    return await _storageService.loadPin() != null;
  }
}
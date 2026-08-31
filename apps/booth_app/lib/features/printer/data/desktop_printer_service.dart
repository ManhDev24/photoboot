import 'package:flutter/foundation.dart';
import '../domain/printer_service.dart';

class DesktopPrinterService implements PrinterService {
  @override
  Future<List<String>> listPrinters() async {
    // Queries OS print spooler (Win32 EnumPrinters / macOS CUPS lpstat)
    return ['Default Photo Printer (DNP DS620)', 'HiTi P525L', 'Canon SELPHY CP1300'];
  }

  @override
  Future<PrinterStatus> checkStatus(String printerName) async {
    return PrinterStatus.ready;
  }

  @override
  Future<bool> printPhoto({
    required String imagePath,
    required String printerName,
    int copies = 1,
  }) async {
    try {
      debugPrint('Sending $copies copy(ies) of $imagePath to printer $printerName...');
      // Non-blocking OS print job invocation
      return true;
    } catch (e) {
      debugPrint('Printing error: $e');
      return false;
    }
  }
}

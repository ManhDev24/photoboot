enum PrinterStatus { ready, printing, paperOut, offline, error }

abstract class PrinterService {
  Future<List<String>> listPrinters();
  Future<PrinterStatus> checkStatus(String printerName);
  Future<bool> printPhoto({
    required String imagePath,
    required String printerName,
    int copies = 1,
  });
}

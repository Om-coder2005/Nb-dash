import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;

class EscPosPrinter {
  final PaperSize paperSize;
  final CapabilityProfile profile;
  late final Generator _generator;

  EscPosPrinter({
    required this.paperSize,
    required this.profile,
  }) {
    _generator = Generator(paperSize, profile);
  }

  /// Resets printer settings to defaults.
  List<int> reset() {
    return _generator.reset();
  }

  /// Writes standard text with formatting styles.
  List<int> text(
    String text, {
    PosStyles styles = const PosStyles(),
    int linesAfter = 0,
  }) {
    return _generator.text(text, styles: styles, linesAfter: linesAfter);
  }

  /// Prints a multi-column row (up to width of 12 columns).
  List<int> row(List<PosColumn> columns) {
    return _generator.row(columns);
  }

  /// Prints a horizontal rule line.
  List<int> hr({String ch = '-', int? len}) {
    return _generator.hr(ch: ch, len: len);
  }

  /// Feeds the paper by a number of lines.
  List<int> feed(int lines) {
    return _generator.feed(lines);
  }

  /// Feeds paper slightly and cuts.
  List<int> cut() {
    return _generator.cut();
  }

  /// Sends a Pulse to Open the Cash Drawer.
  /// [pin] 2: Drawer Pin 2 (Standard, ESC p 0)
  /// [pin] 5: Drawer Pin 5 (ESC p 1)
  List<int> openCashDrawer({int pin = 2}) {
    if (pin == 5) {
      return [0x1B, 0x70, 0x01, 0x19, 0xFA]; // Pulse to Pin 5
    }
    return [0x1B, 0x70, 0x00, 0x19, 0xFA]; // Pulse to Pin 2 (standard)
  }

  /// Prints standard barcodes (e.g. Code 128 / Code 39).
  List<int> barcode(
    String code, {
    BarcodeText textPosition = BarcodeText.below,
    int height = 50,
  }) {
    // Generate Code 128 barcode
    final barcodeData = Barcode.code128(code.codeUnits);
    return _generator.barcode(
      barcodeData,
      width: 2,
      height: height,
      font: BarcodeFont.fontA,
      textPos: textPosition,
    );
  }

  /// Prints a QR code using standard ESC/POS QR commands.
  List<int> qrCode(
    String text, {
    QRSize size = QRSize.size4,
  }) {
    return _generator.qrcode(text, size: size);
  }

  /// Prints an image (logo) using legacy ESC * bit-image command for maximum printer compatibility.
  List<int> image(img.Image image, {PosAlign align = PosAlign.center}) {
    return _generator.image(image, align: align);
  }
}

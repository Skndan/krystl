import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Created by Balaji Malathi on 1/25/2025 at 22:37.

class QrScannerView extends StatefulWidget {
  final Function(String) onDetect;

  const QrScannerView({super.key, required this.onDetect});

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> {

  Barcode? _barcode;

  void _buildBarcode(Barcode value) {
    widget.onDetect(value.displayValue ?? '');
  }

  void _handleBarcode(BarcodeCapture barcodes) {

    if (!mounted) {
      return;
    }

    _barcode = barcodes.barcodes.firstOrNull;

    if (_barcode != null) {
      // Pause the scanner for 5 seconds
      controller.stop();

      // Barcode detected and processed
      _buildBarcode(_barcode!);
    }
  }

  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(const Offset(0, -100)),
      width: 200,
      height: 200,
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: MobileScanner(
            fit: BoxFit.cover,
            controller: controller,
            onDetect: _handleBarcode,
            scanWindow: scanWindow,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            if (!value.isInitialized ||
                !value.isRunning ||
                value.error != null ||
                scanWindow.isEmpty) {
              return const SizedBox();
            }

            return ScanWindowOverlay(
              controller: controller,
              scanWindow: scanWindow,
              borderStrokeCap: StrokeCap.butt,
              borderStrokeJoin: StrokeJoin.round,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ToggleFlashlightButton(controller: controller),
                SwitchCameraButton(controller: controller),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return IconButton(
              color: Colors.white,
              iconSize: 24.0,
              icon: const Icon(Icons.flash_auto),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.off:
            return IconButton(
              color: Colors.white,
              iconSize: 24.0,
              icon: const Icon(Icons.flash_off),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.on:
            return IconButton(
              color: Colors.white,
              iconSize: 24.0,
              icon: const Icon(Icons.flash_on),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.unavailable:
            return const SizedBox.square(
              dimension: 48.0,
              child: Icon(
                Icons.no_flash,
                size: 24.0,
                color: Colors.grey,
              ),
            );
        }
      },
    );
  }
}

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final int? availableCameras = state.availableCameras;

        if (availableCameras != null && availableCameras < 2) {
          return const SizedBox.shrink();
        }

        final Widget icon;

        switch (state.cameraDirection) {
          case CameraFacing.front:
            icon = const Icon(Icons.camera_front);
          case CameraFacing.back:
            icon = const Icon(Icons.camera_rear);
        }

        return IconButton(
          color: Colors.white,
          iconSize: 24.0,
          icon: icon,
          onPressed: () async {
            await controller.switchCamera();
          },
        );
      },
    );
  }
}

class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
  });

  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        final values = scannedBarcodes.map((e) => e.displayValue).join(', ');

        if (scannedBarcodes.isEmpty) {
          return const Text(
            'Scan something!',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          );
        }

        return Text(
          values.isEmpty ? 'No display value.' : values,
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// This widget represents an overlay that paints a scan window cutout.
class ScanWindowOverlay extends StatelessWidget {
  /// Construct a new [ScanWindowOverlay] instance.
  const ScanWindowOverlay({
    super.key,
    required this.controller,
    required this.scanWindow,
    this.borderColor = Colors.white,
    this.borderRadius = BorderRadius.zero,
    this.borderStrokeCap = StrokeCap.butt,
    this.borderStrokeJoin = StrokeJoin.miter,
    this.borderStyle = PaintingStyle.stroke,
    this.borderWidth = 2.0,
    this.color = const Color(0x80000000),
  });

  /// The color for the scan window border.
  ///
  /// Defaults to [Colors.white].
  final Color borderColor;

  /// The border radius for the scan window and its border.
  ///
  /// Defaults to [BorderRadius.zero].
  final BorderRadius borderRadius;

  /// The stroke cap for the border around the scan window.
  ///
  /// Defaults to [StrokeCap.butt].
  final StrokeCap borderStrokeCap;

  /// The stroke join for the border around the scan window.
  ///
  /// Defaults to [StrokeJoin.miter].
  final StrokeJoin borderStrokeJoin;

  /// The style for the border around the scan window.
  ///
  /// Defaults to [PaintingStyle.stroke].
  final PaintingStyle borderStyle;

  /// The width for the border around the scan window.
  ///
  /// Defaults to 2.0.
  final double borderWidth;

  /// The color for the scan window box.
  ///
  /// Defaults to [Colors.black] with 50% opacity.
  final Color color;

  /// The controller that manages the camera preview.
  final MobileScannerController controller;

  /// The scan window for the overlay.
  final Rect scanWindow;

  @override
  Widget build(BuildContext context) {
    if (scanWindow.isEmpty || scanWindow.isInfinite) {
      return const SizedBox();
    }

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        // Not ready.
        if (!value.isInitialized ||
            !value.isRunning ||
            value.error != null ||
            value.size.isEmpty) {
          return const SizedBox();
        }

        return CustomPaint(
          size: value.size,
          painter: ScanWindowPainter(
            borderColor: borderColor,
            borderRadius: borderRadius,
            borderStrokeCap: borderStrokeCap,
            borderStrokeJoin: borderStrokeJoin,
            borderStyle: borderStyle,
            borderWidth: borderWidth,
            scanWindow: scanWindow,
            color: color,
            cornerLength: 36,
            cornerWidth: 12,
            cornerColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
      },
    );
  }
}

/// This class represents a [CustomPainter] that draws a [scanWindow] rectangle.
class ScanWindowPainter extends CustomPainter {
  /// Construct a new [ScanWindowPainter] instance.
  const ScanWindowPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.borderStrokeCap,
    required this.borderStrokeJoin,
    required this.borderStyle,
    required this.borderWidth,
    required this.color,
    required this.scanWindow,
    required this.cornerLength,
    required this.cornerWidth,
    required this.cornerColor,
  });

  /// The color for the scan window border.
  final Color borderColor;

  /// The border radius for the scan window and its border.
  final BorderRadius borderRadius;

  /// The stroke cap for the border around the scan window.
  final StrokeCap borderStrokeCap;

  /// The stroke join for the border around the scan window.
  final StrokeJoin borderStrokeJoin;

  /// The style for the border around the scan window.
  final PaintingStyle borderStyle;

  /// The width for the border around the scan window.
  final double borderWidth;

  /// The color for the scan window box.
  final Color color;

  /// The rectangle that defines the scan window.
  final Rect scanWindow;

  /// Length of the bold corners.
  final double cornerLength;

  /// Width of the bold corners.
  final double cornerWidth;

  /// Color of the bold corners.
  final Color cornerColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (scanWindow.isEmpty || scanWindow.isInfinite) {
      return;
    }

    // Define the main overlay path covering the entire screen.
    final backgroundPath = Path()..addRect(Offset.zero & size);

    // The cutout rect depends on the border radius.
    final RRect cutoutRect = borderRadius == BorderRadius.zero
        ? RRect.fromRectAndCorners(scanWindow)
        : RRect.fromRectAndCorners(
            scanWindow,
            topLeft: borderRadius.topLeft,
            topRight: borderRadius.topRight,
            bottomLeft: borderRadius.bottomLeft,
            bottomRight: borderRadius.bottomRight,
          );

    // The cutout path is always in the center.
    final Path cutoutPath = Path()..addRRect(cutoutRect);

    // Combine the two paths: overlay minus the cutout area
    final Path overlayWithCutoutPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final Paint overlayWithCutoutPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcOver; // android

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = borderStyle
      ..strokeWidth = borderWidth
      ..strokeCap = borderStrokeCap
      ..strokeJoin = borderStrokeJoin;

    final Paint cornerPaint = Paint()
      ..color = cornerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerWidth;

    // Paint the overlay with the cutout.
    canvas.drawPath(overlayWithCutoutPath, overlayWithCutoutPaint);

    // Draw the border around the cutout area.
    canvas.drawRRect(cutoutRect, borderPaint);

    // Draw bold corners.
    _drawBoldCorners(canvas, cutoutRect, cornerPaint);
  }

  void _drawBoldCorners(Canvas canvas, RRect rect, Paint paint) {
    final double offset = cornerWidth / 2;

    // Top-left corner.
    canvas.drawLine(
      Offset(rect.left - offset, rect.top),
      Offset(rect.left + cornerLength, rect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top - offset),
      Offset(rect.left, rect.top + cornerLength),
      paint,
    );

    // Top-right corner.
    canvas.drawLine(
      Offset(rect.right - cornerLength, rect.top),
      Offset(rect.right + offset, rect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.top - offset),
      Offset(rect.right, rect.top + cornerLength),
      paint,
    );

    // Bottom-left corner.
    canvas.drawLine(
      Offset(rect.left - offset, rect.bottom),
      Offset(rect.left + cornerLength, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.bottom - cornerLength),
      Offset(rect.left, rect.bottom + offset),
      paint,
    );

    // Bottom-right corner.
    canvas.drawLine(
      Offset(rect.right - cornerLength, rect.bottom),
      Offset(rect.right + offset, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.bottom - cornerLength),
      Offset(rect.right, rect.bottom + offset),
      paint,
    );
  }

  @override
  bool shouldRepaint(ScanWindowPainter oldDelegate) {
    return oldDelegate.scanWindow != scanWindow ||
        oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.cornerLength != cornerLength ||
        oldDelegate.cornerWidth != cornerWidth ||
        oldDelegate.cornerColor != cornerColor;
  }
}

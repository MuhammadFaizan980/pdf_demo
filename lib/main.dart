import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as PDF;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

main() => runApp(
      const MaterialApp(
        home: ImageToPdgDemo(),
      ),
    );

class ImageToPdgDemo extends StatefulWidget {
  const ImageToPdgDemo({Key? key}) : super(key: key);

  @override
  _ImageToPdgDemoState createState() => _ImageToPdgDemoState();
}

class _ImageToPdgDemoState extends State<ImageToPdgDemo> {
  XFile? file;
  String? path;
  File? pdfFile;

  @override
  void initState() {
    _getPath();
    super.initState();
  }

  Future<void> _getPath() async {
    path = (await getTemporaryDirectory()).path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image to PDF Demo'),
        actions: [
          IconButton(
            onPressed: () async {
              file = await ImagePicker().pickImage(
                source: ImageSource.camera,
              );
              if (file != null) {
                final pdf = pw.Document();
                pdf.addPage(
                  pw.Page(
                    pageFormat: PDF.PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Center(
                        child: pw.Image(
                          pw.MemoryImage(
                            File(file!.path).readAsBytesSync(),
                          ),
                        ),
                      ); // Center
                    },
                  ),
                );
                pdfFile = File("$path/example.pdf");
                await pdfFile!.writeAsBytes(await pdf.save());
                setState(() {});
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: pdfFile != null
          ? PDFView(
              pdfData: pdfFile!.readAsBytesSync(),
            )
          : const Text('Tap + icon to add an image'),
    );
  }
}

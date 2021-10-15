import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:spicyguitaracademy_app/services/cache_manager.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

class PdfWidget extends StatefulWidget {
  final String? url;

  const PdfWidget({Key? key, @required this.url}) : super(key: key);

  @override
  _PdfWidgetState createState() => _PdfWidgetState();
}

class _PdfWidgetState extends State<PdfWidget> {
  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<PDFDocument> loadPdf() async {
    return cacheManager(widget.url!).then((value) async {
      return await PDFDocument.fromFile(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadPdf(),
        builder: (BuildContext context, AsyncSnapshot<PDFDocument> snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(darkbrown),
                ))
              : PDFViewer(
                  document: snapshot.data!,
                  zoomSteps: 1,
                  maxScale: 2.0,
                );
        });
  }
}

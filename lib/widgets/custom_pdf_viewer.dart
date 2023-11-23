import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spicyguitaracademy_app/services/cache_manager.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

class PdfWidget extends StatefulWidget {
  final String? url;

  const PdfWidget({Key? key, @required this.url}) : super(key: key);

  @override
  _PdfWidgetState createState() => _PdfWidgetState();
}

class _PdfWidgetState extends State<PdfWidget> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    loadPdf(widget.url!);
  }

  Future<PDFDocument> loadPdf(String url) async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getString('resource_$url') == null) {
      print("\n\n\nLesson do not Exist\n\n");
      return await PDFDocument.fromURL(url);
    } else {
      print("\n\n\nLesson do Exist\n\n");
      return getCachedFile(widget.url!).then((value) async {
        return await PDFDocument.fromFile(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadPdf(widget.url!),
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
      },
    );
  }
}

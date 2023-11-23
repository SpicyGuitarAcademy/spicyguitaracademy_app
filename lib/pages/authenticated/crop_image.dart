import 'dart:typed_data';
import 'dart:io';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/utils/upload.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class CropImage extends StatefulWidget {
  @override
  _CropImageState createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  final _cropController = CropController();
  var _loadingImage = false;

  var _isSumbnail = false;
  var _isCropping = false;
  var _isCircleUi = false;
  Uint8List? _imageData;
  Uint8List? _croppedData;
  var _statusText = '';

  File? file;
  bool _hasLoaded = false;
  bool _isCropped = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadImage() async {
    setState(() {
      _loadingImage = true;
    });
    dynamic map = getRouteArgs(context);
    file = map['file'];
    print(file);
    _imageData = file!.readAsBytesSync();
    setState(() {
      // _cropController.image = _imageData!;
      _loadingImage = false;
      _hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLoaded) _loadImage();
    return Consumer<Student>(builder: (BuildContext context, student, child) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          iconTheme: IconThemeData(color: brown),
          backgroundColor: grey,
          centerTitle: true,
          title: Text(
            'Crop Image',
            style: TextStyle(
                color: brown,
                fontSize: 30,
                fontFamily: "Poppins",
                fontWeight: FontWeight.normal),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          minimum: EdgeInsets.all(5.0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Visibility(
                visible: !_loadingImage && !_isCropping,
                child: Column(
                  children: [
                    Expanded(
                      child: Visibility(
                        visible: _croppedData == null,
                        child: Stack(
                          children: [
                            Crop(
                              controller: _cropController,
                              image: _imageData!,
                              onCropped: (croppedData) {
                                setState(() {
                                  _croppedData = croppedData;
                                  _isCropping = false;
                                });
                              },
                              withCircleUi: _isCircleUi,
                              onStatusChanged: (status) => setState(() {
                                _statusText = <CropStatus, String>{
                                      CropStatus.nothing:
                                          'Crop has no image data',
                                      CropStatus.loading:
                                          'Crop is now loading given image',
                                      CropStatus.ready: 'Crop is now ready!',
                                      CropStatus.cropping:
                                          'Crop is now cropping image',
                                    }[status] ??
                                    '';
                              }),
                              initialSize: 0.5,
                              maskColor: _isSumbnail ? Colors.white : null,
                              cornerDotBuilder: (size, edgeAlignment) =>
                                  _isSumbnail
                                      ? const SizedBox.shrink()
                                      : const DotControl(),
                            ),
                            Positioned(
                              right: 16,
                              bottom: 16,
                              child: GestureDetector(
                                onTapDown: (_) =>
                                    setState(() => _isSumbnail = true),
                                onTapUp: (_) =>
                                    setState(() => _isSumbnail = false),
                                child: CircleAvatar(
                                  backgroundColor: _isSumbnail
                                      ? Colors.blue.shade50
                                      : Colors.blue,
                                  child: Center(
                                    child: Icon(Icons.crop_free_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        replacement: Center(
                          child: _croppedData == null
                              ? SizedBox.shrink()
                              : Image.memory(_croppedData!),
                        ),
                      ),
                    ),
                    if (_croppedData == null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.crop_7_5),
                                  onPressed: () {
                                    _isCircleUi = false;
                                    _cropController.aspectRatio = 16 / 4;
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.crop_16_9),
                                  onPressed: () {
                                    _isCircleUi = false;
                                    _cropController.aspectRatio = 16 / 9;
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.crop_5_4),
                                  onPressed: () {
                                    _isCircleUi = false;
                                    _cropController.aspectRatio = 4 / 3;
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.crop_square),
                                  onPressed: () {
                                    _isCircleUi = false;
                                    _cropController
                                      ..withCircleUi = false
                                      ..aspectRatio = 1;
                                  },
                                ),
                                IconButton(
                                    icon: Icon(Icons.circle),
                                    onPressed: () {
                                      _isCircleUi = true;
                                      _cropController.withCircleUi = true;
                                    }),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isCropping = true;
                                  });
                                  _isCircleUi
                                      ? _cropController.cropCircle()
                                      : _cropController.crop();
                                  setState(() {
                                    _isCropped = true;
                                  });
                                },
                                child: Text('CROP'),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (_isCropped == true)
                      Container(
                        width: screen(context).width,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              final tempDir = await getTemporaryDirectory();
                              File file =
                                  await File('${tempDir.path}/image.png')
                                      .create();
                              file.writeAsBytesSync(_croppedData!);

                              print(file);

                              loading(context, message: 'Uploading');

                              var resp = await upload(
                                '/api/student/avatar/update',
                                'avatar',
                                file,
                                method: 'POST',
                                headers: {
                                  'JWToken': Auth.token!,
                                  'cache-control': 'max-age=0, must-revalidate'
                                },
                              );

                              if (resp['status'] == true) {
                                setState(() =>
                                    student.avatar = resp['data']['path']);
                              }

                              Navigator.popUntil(
                                  context, ModalRoute.withName('/dashboard'));
                              setState(() {});
                            } catch (e) {
                              Navigator.pop(context);
                              error(context, stripExceptions(e));
                            }
                          },
                          child: Text('Upload'),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
                replacement: const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      );
    });
  }
}

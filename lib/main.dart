import 'package:flutter/material.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  bool? _loading;
  List<dynamic>? _outputs;
  final _imagePicker = ImagePicker();

  void initState() {
    super.initState();
      _loading = true;

      loadModel().then((value) {
        setState( () {
          _loading = false;
        });
      });
  }
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  pickImage() async {
    var image = await _imagePicker.getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  // Classify the image selected

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _loading = false;
      // Declare List _outputs in the class which will be used to show the classified class name and confidence
      _outputs = output;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text("Food Image Recogniser"),
      ),
      body: _loading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
      )
    : Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
            // if image is null then will show a empty container
                ? Container(
                    child: Text("Please choose a valid image"),
            )
                : Container(
                    child: Image.file(_image),
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                  ),
            SizedBox(
              height: 20,
            ),
            _outputs != null
                ? Text(
                    "${_outputs[0]["label"]}".replaceAll(RegExp(r'[0-10]'), ''),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      background: Paint()..color = Colors.white,
                      fontWeight: FontWeight.bold
                    ),
            )
                : Text("WAITING")
          ],
        ),
      ) ,
    floatingActionButton: FloatingActionButton(
      onPressed: pickImage,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    ),
    );
  }
}

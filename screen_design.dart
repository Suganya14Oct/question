import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:question_answer/controller/button_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:signature/signature.dart';

class ScreenDesign extends StatefulWidget {
  const ScreenDesign({super.key});

  @override
  State<ScreenDesign> createState() => _ScreenDesignState();
}

class _ScreenDesignState extends State<ScreenDesign> {

  @override
  void initState() {

    getApi();
    postApi();

    super.initState();
  }

  var responce;

  Map? responcebody;

  Future getApi() async {

    var url = "http://193.43.134.235:8090/m&d/workerapp/health_safe_list?userid=4";
    responce = await http.get(Uri.parse(url));
    responcebody = json.decode(responce.body);
    print(responcebody);
    print(responcebody!["data"][0]["title"]);
  }

  void postApi() async {

    var dio = Dio();
    var responce = await dio.post("http://127.0.0.1:8000/m&d/workerapp/Daily_healthsafe",
        data: {
          "userid" : "4",
          "project_id" : "1",
          "title" : [],
          "yes_no" : [],
          "emp_signature" : exportedImage
        }
    );
    print(responce.data);

  }

    Uint8List? exportedImage;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
     exportBackgroundColor: Colors.white10,
  );

  String selectedOption = "";

  List<String> options = ["Yes","Yes","Yes","Yes","Yes","Yes","Yes","Yes","Yes","Yes","Yes"];

  @override
  Widget build(BuildContext context) {

    Get.put(ButtonController());

    return Scaffold(
      appBar: AppBar(
        title: Text("HEALTH & SAFETY",),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xffB81736),
                    Color(0xff281537)
                  ])
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    //padding: EdgeInsets.all(10.0),
                    //margin: EdgeInsets.all(10.0),
                    child: Image.asset("assets/mdicon.png"),
                    height: 70,
                    width: 100,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(10.0),
                    child: Text("Health & Safety Policy",style: TextStyle(color: Colors.red,
                        fontWeight: FontWeight.bold,fontSize: 17.0),),
                    height: 90,
                    width: 200,
                    //color: Colors.red,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 150,
                    padding: EdgeInsets.only(left: 20.0 ),
                    margin: EdgeInsets.all(10.0),
                    //color: Colors.red,
                    child: Text("Health Enquiry",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Colors.red),),
                  ),
                  Container(
                    height: 40,
                    width: 150,
                    padding: EdgeInsets.only(left: 20.0 ),
                    margin: EdgeInsets.all(10.0),
                    //color: Colors.red,
                    child: Text("View Crew",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Colors.red),),
                  )
                ],
              ),
                responcebody == null ?
                Container(child: Center(child: CircularProgressIndicator()),) :
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 11,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text('${responcebody!["data"][index]["title"].toString()}'),
                            ),
                            OrderTypeButton(value: 'yes', title: '', color: Colors.green, isfree: true),
                            OrderTypeButton(value: 'no', title: '', color: Colors.red, isfree: false)
                          ],
                        );
                      },),
                  ),
                ),
              Container(
                height: 30,
                width: 320,
                color: Colors.white10,
                child: Text("Signature",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 17.0),),
              ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(left: 20.0),
                         child: Card(
                           elevation: 7.0,
                           child: Signature(
                             controller: _controller,
                              width: 270,
                              height: 60,
                               backgroundColor: Colors.grey.shade100,
                  ),
                         ),
                       ),
                       Container(
                         height: 50,
                         width: 60,
                         //color: Colors.red,
                         child: InkWell(
                           onTap: () {
                             setState(() {
                               _controller.clear();
                             });
                           },
                             child: Icon(Icons.edit,size: 28,color: Colors.red,)),
                       )
                     ],
                   ),
              SizedBox(height: 10.0,),
              InkWell(
                onTap: () async{
                  exportedImage = await _controller.toPngBytes();
                  Fluttertoast.showToast(msg: "Scroll Up");
                  print("object");
                  setState(() {

                  });

                },
                child: Container(
                  height: 50,
                  width: 250,
                  child: Center(child: Text("Continue",
                    style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),
                  )),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color(0xffB81736),
                            Color(0xff281537)
                          ]),
                      borderRadius: BorderRadius.all(Radius.circular(35))
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              if(exportedImage != null) Image.memory(exportedImage!)
            ],
          ),
        ),
      ),
    );
  }
}


class OrderTypeButton extends StatelessWidget {

   String value;
  final String title;
  final Color color;
  final bool isfree;

  OrderTypeButton ({

    required this.value, required this.title, required this.color, required this.isfree

  });

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ButtonController>(builder: (buttonController){
      return InkWell(
        onTap: () => buttonController.setType(value),
        child: Row(
          children: [
            Radio(
                value: value,
                groupValue: buttonController.type,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (val){
                  value = val.toString();
                },
              activeColor: color
            ),
            SizedBox(width: 10,),
            Text(title),
            SizedBox(width: 5,),
            Text('${(value == 'yes' || isfree) ? 'Yes' : color == Colors.green ? Colors.red : 'No'}')
          ],
        ),
      );
    });

  }
}


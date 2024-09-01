import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notlar_app/NotDetaySayfa.dart';
import 'package:notlar_app/NotKayitSayfa.dart';
import 'package:notlar_app/Notlar.dart';

import 'Notlardao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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

  Future<List<Notlar>> tumNotlariGoster() async {
    var notlarListesi = await Notlardao().tumNotlar();

    return notlarListesi;
  }
  Future<bool> uygulmayiKapat() async {
    await exit(0);


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            uygulmayiKapat();
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Notlar Uygulaması",style: TextStyle(color: Colors.white,fontSize: 16),),
            FutureBuilder(
             future: tumNotlariGoster(),
             builder: (context,snapshot) {
               if (snapshot.hasData) {
                 var notlarListesi = snapshot.data;

                 double ortalama = 0.0;

                 if(!notlarListesi!.isEmpty){
                   double toplam = 0.0;

                   for(var n in notlarListesi){
                     toplam = toplam + (n.not1 + n.not2) / 2;
                   }

                   ortalama = toplam / notlarListesi.length;
                 }
                 return Text("Ortalama : ${ortalama.toInt()} ",style: TextStyle(color: Colors.white,fontSize: 14),);
               } else {
                 return Text("Ortalama : 0 ",style: TextStyle(color: Colors.white,fontSize: 14),);
               }
             }
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: uygulmayiKapat,
        child: FutureBuilder<List<Notlar>>(
          future: tumNotlariGoster(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              var notlarListesi = snapshot.data;
              return ListView.builder(
                itemCount: notlarListesi!.length,
                itemBuilder: (context,index){
                  var not = notlarListesi[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => NotDetaySayfa(not: not,)));
                    },
                    child: Card(
                      child: SizedBox(height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(not.ders_adi,style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(not.not1.toString()),
                            Text(not.not2.toString()),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }else{
              return Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context) => NotKayitSayfasi()));

        },
        tooltip: 'Not Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}

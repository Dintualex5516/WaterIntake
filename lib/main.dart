import "package:flutter/material.dart";
import'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(const WaterIntakeApp());
}

class WaterIntakeApp extends StatelessWidget {
  const WaterIntakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'water intake app',
      theme: ThemeData(
        primarySwatch: Colors.blue,useMaterial3: true
      ),
      home:const WaterIntakeHomePage(),
    );
  }
}

class WaterIntakeHomePage extends StatefulWidget {
  const WaterIntakeHomePage({super.key});

  @override
  State<WaterIntakeHomePage> createState() => _WaterIntakeHomePageState();
}

class _WaterIntakeHomePageState extends State<WaterIntakeHomePage> {

  int _waterIntake=0;
  int _dailyGoal=8;
  final List<int> _dailyGoalOptions=[8,10,12];

  @override
  void initState(){
    super.initState();
    _loadpreferences();

  }

  Future<void> _loadpreferences() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    setState(() {
      _waterIntake=(pref.getInt('waterIntake')?? 0);
      _dailyGoal=(pref.getInt('dailyGoal')?? 8);

    });
  }


  Future <void> _incrementWaterIntake()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    setState(() {
      _waterIntake++;
      pref.setInt('waterIntake',_waterIntake);

      if(_waterIntake >= _dailyGoal){
        // dialog box

        _showGoalReachedDialog();
      }
    });
  }


  Future <void> _resetWaterIntake()async{
  SharedPreferences pref =await SharedPreferences.getInstance();
  setState(() {
    _waterIntake = 0;
    pref.setInt('waterIntake',_waterIntake);


  });
  
  }

  Future <void> _setDailyGoal(int newGoal)async
  {
    SharedPreferences pref=await SharedPreferences.getInstance();
    setState(() {
      _dailyGoal=newGoal;
      pref.setInt('dailyGoal',newGoal);
    });
  }

  Future<void> _showGoalReachedDialog()async{
    return showDialog<void>(context: context,
     barrierDismissible: false,
     builder:(BuildContext context){
      return AlertDialog(
        title:const Text('Congratulations'),
        content:SingleChildScrollView(
          child:ListBody(
            children: [Text('you have reached your daily goal of $_dailyGoal'),

            ],
          )
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();

        },child: const Text('OK'))],
      );
     } 
     );
  }
 


 Future<void> _showResetConfirmationDialog()async{
    return showDialog<void>(context: context,
     barrierDismissible: false,
     builder:(BuildContext context){
      return AlertDialog(
        title:const Text('Reset Water iNtake'),
        content:const SingleChildScrollView(
          child:ListBody(
            children: [Text('Are u sure  u want to reset ur water intake ?'),

            ],
          )
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();

        },child: const Text('Cancel')),
        TextButton(onPressed: (){
          _resetWaterIntake();
          Navigator.of(context).pop();

        }, child: const Text("Reset"))
        ],
      );
     } 
 );}
  


  @override
 Widget build(BuildContext context) {
  double progress = _dailyGoal > 0 ? _waterIntake / _dailyGoal : 0;

  return Scaffold(
    appBar: AppBar(
      title: const Text("Water Intake App"),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _showResetConfirmationDialog,
        ),
      ],
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.water_drop, size: 120, color: Colors.blue),
            const SizedBox(height: 10.0),
            const Text(
              "You have consumed: ",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "$_waterIntake glass  of water",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10.0),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.blueGrey,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
              minHeight: 20,
            ),
            const SizedBox(height: 10),
            const Text(
              'Daily Goal',
              style: TextStyle(fontSize: 18),
            ),
            DropdownButton<int>(
              value: _dailyGoal,
              items: _dailyGoalOptions.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value glasses'),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  _setDailyGoal(newValue);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:(){_incrementWaterIntake();
              } ,
              child: const Text('Add Glass of Water'),
            ),
            const SizedBox(height: 20),
             ElevatedButton(
              onPressed:_showResetConfirmationDialog,
               
              child: const Text('RESET' ,style:TextStyle(fontSize:18)),
            ),

          ],
        ),
      ),
    ),
  );
}}
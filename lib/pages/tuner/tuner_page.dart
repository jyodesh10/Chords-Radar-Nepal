import 'package:chord_radar_nepal/constants/constants.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:syncfusion_flutter_gauges/gauges.dart";

import '../../bloc/tuner_bloc/tuner_bloc.dart';
import '../../bloc/tunings_cubit/tunings_cubit.dart';
import '../../widgets/dialogs.dart';

class TunerPage extends StatefulWidget {
  const TunerPage({super.key});

  @override
  State<TunerPage> createState() => _TunerPageState();
}

class _TunerPageState extends State<TunerPage> {
  List standard = ["E", "A", "D", "G", "B", "E"];
  var selectedIntrumentIndex  =3;
  var selectedTuningIndex  =0;
  String openr ="A#DA#D#GC";
  List  st =[];
  List<String> chars = [];




  @override
  void initState() {
    super.initState();
    recordPerm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<TunerBloc>(context).add(const StartRecordingEvent());
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future recordPerm()async{
    final result = await Permission.microphone.request();
    if (result.isGranted) {
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
          "Permission Denied"
        )));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<TunerBloc>(context).add(const StopRecordingEvent());
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.charcoal,
        body: Container(
          color: AppColors.charcoal,
          child: BlocBuilder<TunerBloc, TunerState>(
            builder: (context, state) {
              return Center(
                child: Column(children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<TunerBloc>(context).add(const StopRecordingEvent());
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          FluentIcons.arrow_circle_left_48_regular,
                          size: 40,
                          color: AppColors.deepTeal,
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: context.read<TunerBloc>().status ==
                                "TuningStatus.undefined"
                            ? const SizedBox(
                              height: 100,
                              )
                            : Center(
                              child: Text(
                                context.watch<TunerBloc>().note,
                                style: TextStyle(
                                    color: context.read<TunerBloc>().status =="TuningStatus.tuned"?AppColors.olive: AppColors.burntOrange,
                                    fontSize: 60.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                        },
                        icon: const Icon(Icons.abc_outlined)
                      ),
                    ],
                  ),
                  const Spacer(),
                  _buildRadialGauge(),
                  const Spacer(),
                  const Center(
                      child: Text(
                    "",
                    // context.read<TunerBloc>().status,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 60.0,
                        fontWeight: FontWeight.bold),
                  )),
                  _buildTuningOption(),
                  const Spacer(),
                ]),
              );
            },
          ),
        ),
      ),
    );
  }

  _buildRadialGauge() {
    return BlocBuilder<TunerBloc, TunerState>(
      builder: (context, state) {
        return SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showAxisLine: false,
                showTicks: false,
                minimum: 0,
                maximum: 99,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0, endValue: 33,
                    // color: const Color(0xFFFE2A25),
                    label: 'Low',
                    gradient: const SweepGradient(colors: <Color>[
                      AppColors.deepTeal
                    ], stops: <double>[
                      0.25
                    ]),
                    sizeUnit: GaugeSizeUnit.factor,
                    labelStyle: const GaugeTextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 20),
                    startWidth: 0.40, endWidth: 0.40,
                  ),
                  GaugeRange(
                    startValue: 33, endValue: 66,
                    // color:const Color(0xFFFFBA00),
                    label: 'Tuned',
                    gradient: const SweepGradient(colors: <Color>[
                      AppColors.deepTeal,
                      AppColors.olive
                    ], stops: <double>[
                      0.25,
                      0.75
                    ]),
                    labelStyle: const GaugeTextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 20),
                    startWidth: 0.40, endWidth: 0.40,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                  GaugeRange(
                    startValue: 66, endValue: 99,
                    // color:const Color(0xFF00AB47),
                    label: 'High',
                    gradient: const SweepGradient(colors: <Color>[
                      AppColors.olive
                    ], stops: <double>[
                      0.75
                    ]),
                    labelStyle: const GaugeTextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 20),
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.40, endWidth: 0.40,
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                      value: context.read<TunerBloc>().status ==
                              "TuningStatus.waytoolow"
                          ? 20
                          : context.read<TunerBloc>().status ==
                                  "TuningStatus.toolow"
                              ? 40
                              : context.read<TunerBloc>().status ==
                                      "TuningStatus.tuned"
                                  ? 50
                                  : context.read<TunerBloc>().status ==
                                          "TuningStatus.toohigh"
                                      ? 60
                                      : context.read<TunerBloc>().status ==
                                              "TuningStatus.waytoohigh"
                                          ? 80
                                          : 0,
                      needleStartWidth: 1,
                      needleEndWidth: 5,
                      needleColor: Colors.white,
                      animationDuration: 500,
                      enableAnimation: true,
                      knobStyle: const KnobStyle(
                          knobRadius: 0.09,
                          borderColor: Colors.white,
                          borderWidth: 0.02,
                          color: Colors.black))
                ])
          ],
        );
      },
    );
  }
  
  _buildTuningOption() {
    return BlocBuilder<TuningsCubit, TuningsState>(
      builder: (context, state) {
        if(state is TuningsLoadingState){
          return const Text('Loading....');
        }
        if(state is TuningsLoadedState){

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: (){
                    buildDialog(context, Column(
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        ...List.generate(
                        state.data.data.length,
                        (index) => 
                          ListTile(
                            onTap: (){
                              selectedIntrumentIndex = 3;
                              selectedTuningIndex = 0;
                              setState(() {
                                selectedIntrumentIndex = index;
                                
                              });
                              Navigator.pop(context);
                            },
                            title: Text(
                              state.data.data[index].instrument,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 22),
                            ),
                          )
                        )
                      ],
                    ));
                  },
                  color: Colors.white.withOpacity(0.3),
                  child: Column(
                    children:   [
                      const Text('Select Instrument',style: TextStyle(
                        color: Colors.white
                      ),),
                       Text( state.data.data[selectedIntrumentIndex].instrument[0].toUpperCase()+state.data.data[selectedIntrumentIndex].instrument.substring(1).toLowerCase(),style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                      ),),
                    ],
                  ),
                ),


                ///tunings
                MaterialButton(
                  onPressed: (){
                    buildDialog(context, SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:  [
                          ...List.generate(
                            state.data.data[selectedIntrumentIndex].tunings.length,
                          (index) => 
                            ListTile(
                              onTap: (){
                                st = [];
                                setState(() {
                                  selectedTuningIndex = index;
                                });
                                Navigator.pop(context);
                              },
                              title: Text(
                                state.data.data[selectedIntrumentIndex].tunings[index].name,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 22),
                              ),
                            )
                          )
                        ],
                      ),
                    ));
                  },
                  color: Colors.white.withOpacity(0.3),
                  child: Column(
                    children:  [
                      const Text('Select Tuning',style: TextStyle(
                        color: Colors.white
                      ),),
                      Text( state.data.data[selectedIntrumentIndex].tunings[selectedTuningIndex].name,style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                      ),),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                ...List.generate(
                    state.data.data[selectedIntrumentIndex].tunings[selectedTuningIndex].notes.length,

                    (index) => Text(
                          state.data.data[selectedIntrumentIndex].tunings[selectedTuningIndex].notes[index],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30),
                        ))
              ],
            ),
          ],
        );
        }
        return const Text('Error');
      },
    );
  }
}
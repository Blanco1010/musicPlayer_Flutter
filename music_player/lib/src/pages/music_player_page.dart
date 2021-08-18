import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/models/audioplayer_model.dart';
import 'package:music_player/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new AudioPlayerModel()),
      ],
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Background(),
              Column(
                children: [
                  CustomAppBar(),
                  _ImageDiskRotation(),
                  //Button and Title
                  _TitleButton(),

                  SizedBox(height: 10),
                  Expanded(child: ListItems()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.7,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(70),
            bottomRight: Radius.circular(70),
          ),
          color: Colors.red,
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.center,
            colors: [
              Color(0xff33333E),
              Color(0xff201E28),
            ],
          )),
    );
  }
}

class ListItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final lyrics = getLyrics();

    return Container(
      child: ListWheelScrollView(
        physics: BouncingScrollPhysics(),
        itemExtent: size.height * 0.06,
        diameterRatio: 2,
        children: lyrics
            .map((e) => Text(
                  e,
                  style: TextStyle(
                      fontSize: size.width * 0.05,
                      color: Colors.white.withOpacity(0.6)),
                ))
            .toList(),
      ),
    );
  }
}

class _ImageDiskRotation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      margin: EdgeInsets.only(top: size.height * 0.1),
      child: Row(
        children: [
          //Disk Image
          _ImageDisk(),
          Spacer(),
          //Progress Bar
          _ProgressBar(),
        ],
      ),
    );
  }
}

class _TitleButton extends StatefulWidget {
  @override
  __TitleButtonState createState() => __TitleButtonState();
}

class __TitleButtonState extends State<_TitleButton>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  AnimationController? playAnimation;

  @override
  void initState() {
    playAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    playAnimation!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      margin: EdgeInsets.only(top: size.width * 0.04),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                'Far Away',
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                '-Breaking Benjamin-',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  color: Colors.white.withOpacity(0.4),
                ),
              )
            ],
          ),
          Spacer(),
          FloatingActionButton(
            backgroundColor: Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playAnimation!,
            ),
            elevation: 0,
            highlightElevation: 0,
            onPressed: () {
              final audioPlayerModel =
                  Provider.of<AudioPlayerModel>(context, listen: false);

              print(this.isPlaying);
              if (this.isPlaying) {
                this.isPlaying = false;
                playAnimation!.reverse();
                audioPlayerModel.controller.stop();
              } else {
                playAnimation!.forward();
                this.isPlaying = true;
                audioPlayerModel.controller.repeat();
              }
            },
          )
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final textStyle = TextStyle(
        color: Colors.white.withOpacity(0.4), fontSize: size.width * 0.07);

    return Container(
      child: Column(
        children: [
          Text('00:00', style: textStyle),
          SizedBox(height: 10),
          Stack(
            children: [
              Container(
                width: 3,
                height: 200,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 100,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('00:00', style: textStyle),
        ],
      ),
    );
  }
}

class _ImageDisk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Container(
      padding: EdgeInsets.all(20),
      height: 250,
      width: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              animate: true,
              controller: (animation) =>
                  audioPlayerModel.controller = animation,
              duration: Duration(seconds: 10),
              infinite: true,
              child: Image(image: AssetImage('assets/aurora.jpg')),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ],
        ),
      ),
    );
  }
}

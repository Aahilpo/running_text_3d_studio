import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '3D Running Text Studio',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const StudioPage(),
    );
  }
}

class StudioPage extends StatefulWidget {
  const StudioPage({super.key});

  @override
  State<StudioPage> createState() => _StudioPageState();
}

class _StudioPageState extends State<StudioPage>
    with SingleTickerProviderStateMixin {
  final controller = TextEditingController(
    text: 'SELAMAT DATANG DI TOKO KAMI',
  );

  late AnimationController animation;
  String effect = 'Neon';
  Color textColor = Colors.amber;
  Color bgColor = const Color(0xFF101827);
  double speed = 20;
  double fontSize = 42;
  bool playing = true;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    animation.dispose();
    controller.dispose();
    super.dispose();
  }

  Widget build3DText(String text) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: 2,
    );

    if (effect == 'Neon') {
      return Stack(
        children: [
          Text(text, style: style.copyWith(
            color: textColor,
            shadows: [
              Shadow(color: textColor, blurRadius: 20),
              Shadow(color: textColor, blurRadius: 40),
            ],
          )),
          Text(text, style: style.copyWith(
            color: Colors.white,
            shadows: [
              Shadow(color: textColor, blurRadius: 15),
            ],
          )),
        ],
      );
    }

    if (effect == 'Metallic') {
      return Stack(
        children: [
          for (int i = 8; i > 0; i--)
            Transform.translate(
              offset: Offset(i * 1.5, i * 1.5),
              child: Text(text, style: style.copyWith(
                color: Colors.blueGrey.shade800,
              )),
            ),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Colors.white,
                Colors.blueGrey,
                Colors.white,
                Colors.grey,
              ],
            ).createShader(bounds),
            child: Text(text, style: style.copyWith(
              color: Colors.white,
            )),
          ),
        ],
      );
    }

    return Stack(
      children: [
        for (int i = 7; i > 0; i--)
          Transform.translate(
            offset: Offset(i * 1.5, i * 1.5),
            child: Text(text, style: style.copyWith(
              color: Colors.deepPurple,
            )),
          ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Colors.yellow,
              Colors.pink,
              Colors.cyan,
              Colors.greenAccent,
            ],
          ).createShader(bounds),
          child: Text(text, style: style.copyWith(
            color: Colors.white,
          )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '3D Running Text Studio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Buat Running Text 3D',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          Container(
            height: 220,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final message = controller.text.isEmpty
                        ? 'RUNNING TEXT 3D'
                        : controller.text;

                    final width = math.max(
                      450.0,
                      message.length * fontSize * 0.8,
                    );

                    final x = constraints.maxWidth -
                        animation.value *
                            (constraints.maxWidth + width);

                    return Stack(
                      children: [
                        Positioned(
                          left: x,
                          top: 75,
                          child: build3DText(message),
                        ),
                        const Positioned(
                          left: 12,
                          top: 12,
                          child: Text(
                            'LIVE PREVIEW',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          TextField(
            controller: controller,
            maxLines: 2,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Masukkan tulisan',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Pilih efek tulisan 3D',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          Wrap(
            spacing: 8,
            children: ['Neon', 'Metallic', 'Colorful'].map((item) {
              return ChoiceChip(
                label: Text(item),
                selected: effect == item,
                onSelected: (_) => setState(() => effect = item),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          const Text('Ukuran tulisan'),
          Slider(
            value: fontSize,
            min: 22,
            max: 76,
            onChanged: (v) => setState(() => fontSize = v),
          ),

          const Text('Kecepatan'),
          Slider(
            value: speed,
            min: 5,
            max: 60,
            onChanged: (v) {
              setState(() => speed = v);
              animation.duration = Duration(
                milliseconds: (20000 / (v / 20)).round(),
              );
              if (playing) animation.repeat();
            },
          ),

          const SizedBox(height: 10),
          const Text('Warna tulisan'),
          Wrap(
            spacing: 12,
            children: [
              Colors.amber,
              Colors.cyan,
              Colors.pink,
              Colors.greenAccent,
              Colors.white,
              Colors.orange,
              Colors.purpleAccent,
            ].map((color) {
              return GestureDetector(
                onTap: () => setState(() => textColor = color),
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 17,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),
          const Text('Warna background'),
          Wrap(
            spacing: 12,
            children: [
              const Color(0xFF101827),
              Colors.black,
              Colors.blueGrey,
              Colors.deepPurple,
              Colors.red,
            ].map((color) {
              return GestureDetector(
                onTap: () => setState(() => bgColor = color),
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 17,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    setState(() => playing = !playing);
                    if (playing) {
                      animation.repeat();
                    } else {
                      animation.stop();
                    }
                  },
                  icon: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                  ),
                  label: Text(playing ? 'Pause' : 'Play'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {
                  animation.stop();
                  animation.value = 0;
                  setState(() => playing = false);
                },
                icon: const Icon(Icons.stop),
                label: const Text('Stop'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

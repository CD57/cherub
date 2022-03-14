import 'package:flutter/material.dart';

class DateInfoDisplay extends StatelessWidget {
  final double deviceWidth;
  final double deviceHeight;

  const DateInfoDisplay({
    Key? key,
    required this.deviceWidth,
    required this.deviceHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.green.shade900],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.5, 0.9],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.green.shade900,
                    minRadius: 35.0,
                    child: const Icon(Icons.call, size: 30.0),
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.white70,
                    minRadius: 60.0,
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          AssetImage('assets/images/perfil-min.jpg'),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.green.shade900,
                    minRadius: 35.0,
                    child: const Icon(Icons.message, size: 30.0),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Leonardo Palmeiro',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Flutter Developer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.green.shade900,
                child: const ListTile(
                  title: Text(
                    '5000',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Followers',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green,
                child: const ListTile(
                  title: Text(
                    '5000',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Following',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Email',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'palmeiro.leonardo@gmail.com',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'GitHub',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'https://github.com/leopalmeiro',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Linkedin',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'www.linkedin.com/in/leonardo-palmeiro-834a1755',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        )
      ],
    );
  }
}

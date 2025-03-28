import 'package:flutter/material.dart';

class GateScheduleScreen extends StatelessWidget {
  final List<Map<String, dynamic>> gates;

  GateScheduleScreen({Key? key, required this.gates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gate Schedules'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: gates.length,
        itemBuilder: (context, index) {
          final gate = gates[index];
          final timings = gate['timing'] as List;
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: ExpansionTile(
              title: Text(
                gate['gate_name'] as String,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Gate ID: ${gate['gate_id']}'),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('${gate['gate_id']}',
                    style: TextStyle(color: Colors.white)),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          'Lat: ${gate['location'].latitude.toStringAsFixed(4)}, '
                          'Lng: ${gate['location'].longitude.toStringAsFixed(4)}'),
                      SizedBox(height: 8),
                      Text('Timings:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...timings
                          .map((timing) => Padding(
                                padding: EdgeInsets.only(left: 8.0, top: 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Open: ${timing['open_time']}'),
                                    Text('Close: ${timing['close_time']}'),
                                  ],
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

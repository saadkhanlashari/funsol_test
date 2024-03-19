// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:task_funsol/video_links.dart';
// import 'package:video_player/video_player.dart';

// class VideoMetadata {
//   final double fileSize;
//   final Duration duration;
//   final int width;
//   final int height;

//   VideoMetadata({
//     required this.fileSize,
//     required this.duration,
//     required this.width,
//     required this.height,
//   });
// }

// Future<VideoMetadata?> fetchVideoMetadata(String videoUrl) async {
//   try {
//     final response = await http.head(Uri.parse(videoUrl));

//     if (response.statusCode == 200) {
//       final String? contentLengthHeader = response.headers['content-length'];
//       final String contentTypeHeader = response.headers['content-type'] ?? '';

//       final double fileSize =
//           contentLengthHeader != null ? double.parse(contentLengthHeader) : 0;

//       final RegExp regExp = RegExp(r'duration=(\d*\.\d*)');
//       final Match? match = regExp.firstMatch(contentTypeHeader);
//       final double durationInSeconds =
//           match != null ? double.parse(match.group(1)!) : 0;

//       // Use video_player to get dimensions
//       final videoController = VideoPlayerController.network(videoUrl);
//       await videoController.initialize();

//       final int width = videoController.value.size.width.toInt();
//       final int height = videoController.value.size.height.toInt();

//       await videoController.dispose();

//       return VideoMetadata(
//         fileSize: fileSize,
//         duration: Duration(seconds: durationInSeconds.toInt()),
//         width: width,
//         height: height,
//       );
//     } else {
//       print('Failed to fetch video data: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     print('Error fetching video data: $e');
//     return null;
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final String videoUrl = links[0];
//   final metadata = await fetchVideoMetadata(videoUrl);
//   if (metadata != null) {
//     print('Video Size: ${metadata.fileSize} bytes');
//     print('Duration: ${metadata.duration}');
//     print('Width: ${metadata.width}');
//     print('Height: ${metadata.height}');
//   }
// }

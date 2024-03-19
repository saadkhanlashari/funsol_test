import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_funsol/video_links.dart';
import 'package:video_player/video_player.dart';

class VideoMetadata {
  final double fileSize;
  final Duration duration;
  final int width;
  final int height;
  final bool hasAudio;

  VideoMetadata({
    required this.fileSize,
    required this.duration,
    required this.width,
    required this.height,
    required this.hasAudio,
  });
}

class VideoMetadataScreen extends StatefulWidget {
  const VideoMetadataScreen({super.key});
  @override
  State<VideoMetadataScreen> createState() => _VideoMetadataScreenState();
}

class _VideoMetadataScreenState extends State<VideoMetadataScreen> {
  List<VideoMetadata?> videoMetadataList = [];

  @override
  void initState() {
    super.initState();
    fetchVideoMetadata();
  }

  Future<void> fetchVideoMetadata() async {
    List<VideoMetadata?> metadataList = [];
    for (String url in links) {
      VideoMetadata? metadata = await getVideoMetadata(url);
      metadataList.add(metadata);
    }
    setState(() {
      videoMetadataList = metadataList;
    });
  }

  Future<VideoMetadata?> getVideoMetadata(String videoUrl) async {
    try {
      final response = await http.head(Uri.parse(videoUrl));

      if (response.statusCode == 200) {
        response.body;
        final String? contentLengthHeader = response.headers['content-length'];

        final double fileSize = contentLengthHeader != null
            ? double.parse(contentLengthHeader) / (1024 * 1024)
            : 0;

        final videoController =
            VideoPlayerController.networkUrl(Uri.parse(videoUrl));
        await videoController.initialize();

        final int width = videoController.value.size.width.toInt();
        final duration = videoController.value.duration;
        final int height = videoController.value.size.height.toInt();
        final bool hasAudio = videoController.value.volume > 0.0;

        await videoController.dispose();

        return VideoMetadata(
          fileSize: fileSize,
          duration: duration,
          width: width,
          height: height,
          hasAudio: hasAudio,
        );
      } else {
        log('Failed to fetch video data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error fetching video data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Video Metadata'),
        ),
        body: videoMetadataList.isNotEmpty
            ? ListView.builder(
                itemCount: links.length,
                itemBuilder: (context, index) {
                  VideoMetadata? metadata = videoMetadataList.isNotEmpty
                      ? videoMetadataList[index]
                      : null;
                  return metadata != null
                      ? Card(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'File Size: ${metadata.fileSize.toStringAsFixed(2)} mb'),
                            Text(
                                'Duration: ${metadata.duration.inMinutes} minutes'),
                            Text('size: ${metadata.width}x${metadata.height}'),
                            Text(
                                'Has Audio: ${metadata.hasAudio ? 'Yes' : 'No'}'),
                          ],
                        ))
                      : const SizedBox();
                },
              )
            : const Center(child: CircularProgressIndicator()));
  }
}

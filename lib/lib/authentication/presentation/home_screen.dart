import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_bloc/theme_bloc.dart';
import '../bloc/theme_bloc/theme_event.dart';

class HomeScreen extends StatefulWidget {
  final String loggedInEmail;
  const HomeScreen({super.key, required this.loggedInEmail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final topicController = TextEditingController();

  String templateType = "Default";
  int slideCount = 10;
  String language = "English";
  String model = "gpt-4";

  bool aiImages = false;
  bool imageEachSlide = false;
  bool googleImages = false;
  bool googleText = false;

  final watermarkWidth = TextEditingController();
  final watermarkHeight = TextEditingController();
  final watermarkUrl = TextEditingController();

  bool isLoading = false;
  String? generatedFileUrl;
  File? downloadedFile;

  Future<void> generatePresentation() async {
    final topic = topicController.text.trim();
    if (topic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a topic")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      generatedFileUrl = null;
      downloadedFile = null;
    });

    final body = {
      "topic": topic,
      "email": widget.loggedInEmail,
      "accessId": "YOUR_HARDCODED_ACCESS_ID", // Replace with actual accessId
      "template": templateType == "Default" ? "bullet-point1" : "ed-bullet-point1",
      "language": language.toLowerCase(),
      "slideCount": slideCount,
      "aiImages": aiImages,
      "imageForEachSlide": imageEachSlide,
      "googleImage": googleImages,
      "googleText": googleText,
      "model": model,
      "watermark": {
        "width": watermarkWidth.text,
        "height": watermarkHeight.text,
        "brandURL": watermarkUrl.text,
        "position": "BottomRight",
      }
    };

    try {
      final response = await http.post(
        Uri.parse("https://api.magicslides.app/public/api/ppt_from_topic"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          generatedFileUrl = data['data']['url'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Presentation generated!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "API failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> downloadFile() async {
    if (generatedFileUrl == null) return;

    setState(() => isLoading = true);

    try {
      final response = await http.get(Uri.parse(generatedFileUrl!));
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/presentation.pdf");
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        downloadedFile = file;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File downloaded!")),
      );

      OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
      IconButton(
        icon: Icon(Icons.brightness_6),
        onPressed: () {
          context.read<ThemeBloc>().add(ToggleThemeEvent());
        },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Topic",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: topicController,
              decoration: const InputDecoration(
                hintText: "Enter your topic...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Template Type",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Radio(
                    value: "Default",
                    groupValue: templateType,
                    onChanged: (val) => setState(() => templateType = val!)),
                const Text("Default"),
                Radio(
                    value: "Editable",
                    groupValue: templateType,
                    onChanged: (val) => setState(() => templateType = val!)),
                const Text("Editable"),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              "Advanced Options",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Text("Slide Count: "),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: slideCount,
                  items: List.generate(
                      50, (i) => DropdownMenuItem(value: i + 1, child: Text("${i + 1}"))),
                  onChanged: (val) => setState(() => slideCount = val!),
                ),
              ],
            ),
            Row(
              children: [
                const Text("Language: "),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: language,
                  items: ["English", "Hindi", "Spanish", "Tamil"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => language = val!),
                ),
              ],
            ),
            Row(
              children: [
                const Text("Model: "),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: model,
                  items: ["gpt-4", "gpt-3.5"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => model = val!),
                ),
              ],
            ),

            SwitchListTile(
              title: const Text("AI Images"),
              value: aiImages,
              onChanged: (v) => setState(() => aiImages = v),
            ),
            SwitchListTile(
              title: const Text("Image on Each Slide"),
              value: imageEachSlide,
              onChanged: (v) => setState(() => imageEachSlide = v),
            ),
            SwitchListTile(
              title: const Text("Google Images"),
              value: googleImages,
              onChanged: (v) => setState(() => googleImages = v),
            ),
            SwitchListTile(
              title: const Text("Google Text"),
              value: googleText,
              onChanged: (v) => setState(() => googleText = v),
            ),

            const SizedBox(height: 15),
            const Text(
              "Watermark (Optional)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: watermarkWidth,
              decoration: const InputDecoration(labelText: "Width", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: watermarkHeight,
              decoration: const InputDecoration(labelText: "Height", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: watermarkUrl,
              decoration: const InputDecoration(labelText: "Brand URL", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 25),

            Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                children: [
                  ElevatedButton(
                    onPressed: generatePresentation,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                    child: const Text("Generate", style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 10),
                  if (generatedFileUrl != null)
                    ElevatedButton(
                      onPressed: downloadFile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("Download PDF", style: TextStyle(fontSize: 16)),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

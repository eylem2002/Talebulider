import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tale/core/functions/all_actions.dart';
import 'package:tale/core/models/file_text_model.dart';
import 'package:tale/core/services/elevenlabs_api.dart';
import 'package:tale/core/services/file_service.dart';
import 'package:tale/utils/consts.dart';
import 'package:tale/utils/layout_manager.dart';
import 'package:tale/utils/theme/text_theme.dart';
import 'package:tale/utils/theme/theme_manager.dart';
import 'package:tale/view/widgets/components.dart';

class DocumentAnalyze extends StatefulWidget {
  const DocumentAnalyze({Key? key}) : super(key: key);

  @override
  State<DocumentAnalyze> createState() => _DocumentAnalyzeState();
}

class _DocumentAnalyzeState extends State<DocumentAnalyze> {
  String TTS_OUTPUT = "Hello How can i help you?";

  bool imageCheck = false;
  bool isGeminiTyping = false;

  FlutterTts _flutterTts = FlutterTts();

  List<Map> _voices = [];
  Map? _currentVoice;

  String text = '';
  RxString selectedVoice = 'Adam'.obs;
  String reselectedVoice = 'Adam';
  RxString externalStorage = '/storage/emulated/0/T2V'.obs;
  int? _currentWordStart, _currentWordEnd;
  http.Response? response;

  File? audioFile;

  final textController = TextEditingController();
  final apiKey = TextEditingController();

  RxBool isTalking = false.obs;
  RxBool isGettingVoice = false.obs;
  RxBool isGettingUser = false.obs;
  RxBool isGeneratingVoice = false.obs;

  RxDouble voiceStability = 0.75.obs;
  RxDouble similarityBoost = 1.0.obs;
  double reStability = 0.75;
  double reBoost = 1.0;

  FileService fileService = FileService();
  String? msg;
  File? file;
  final Gemini gemini = Gemini.instance;
  RxList<String> voiceList =
      ['Adam', 'Antoni', 'Rei', 'Bella', 'Conan', 'Charlie', 'Malak'].obs;
  onVoiceSelect(String selectedName) {
    selectedVoice.value = selectedName;
  }

  Map<String, String> voiceMap = {
    'Adam': 'pNInz6obpgDQGcFmaJgB',
    'Antoni': 'ErXwobaYiN019PkySvjV',
    'Rei': 'VR6AewLTigWG4xSOukaG',
    'Bella': 'EXAVITQu4vr4xnSDxMaL',
    'Conan': 'N2lVS1w4EtoT3dr4eOWO',
    'Charlie': 'IKne3meq5aSn9XLyUdCD',
    'Malak': 'ThT5KcBeYPX3keUQqHPh',
  };

  onVoiceFetch() async {
    isGettingVoice.value = !isGettingVoice.value;
    voiceMap = await getVoiceList();
    if (voiceMap != null) {
      voiceList.value = voiceMap.keys.toList();
    }
    isGettingVoice.value = !isGettingVoice.value;
  }

  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "TaleBuilder",
      profileImage:
          "https://firebasestorage.googleapis.com/v0/b/tale-ce0cb.appspot.com/o/taleface.png?alt=media&token=e7630d76-702b-4bcd-bc27-07aff1c04771");
  @override
  void initState() {
    super.initState();
    initTTS();
  }

  Future<void> initTTS() async {
    _flutterTts.setProgressHandler((text, start, end, word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });
  }

  RxInt textCount = 0.obs;
  RxInt voiceLimit = 0.obs;

  @override
  void onInit() async {
    final api = await AllActions().getSharedPref('API_Key');
    if (api != '') {
      apiKey.text = "";
    }

    Future.delayed(const Duration(seconds: 3));

    await AllActions().requestPermission();
    final direct = Directory(externalStorage.value);
    if (await direct.exists()) {
    } else {
      try {
        await direct.create(recursive: true);
      } catch (e) {
        Get.snackbar(
            'No Storage Permission', 'Please check the storage Permission!');
      }
    }
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  onUserInfo() async {
    isGettingUser.value = !isGettingUser.value;
    final limit = await getUserInfo("");
    if (limit != null) {
      voiceLimit.value = limit;
    } else {
      voiceLimit.value = 0;
    }
    isGettingUser.value = !isGettingUser.value;
  }

  onTextToVoice() async {
    final regExp = RegExp(r'\*');

    TTS_OUTPUT = TTS_OUTPUT.replaceAll(regExp, '');
    print("After RegEx ${TTS_OUTPUT}");

    ///here filter the text
    if (TTS_OUTPUT == '') {
      Get.snackbar('Fill in!', 'Please Enter Text!');
    } else {
      if (ELEVENLABS_API_KEY == '') {
        Get.snackbar('Misssing API!', 'Please Enter Your API Key!');
      } else {
        if (TTS_OUTPUT == '') {
          Get.snackbar('Enter Text!', 'Please Enter Your Text!');
        } else {
          if (text == TTS_OUTPUT &&
              reselectedVoice == selectedVoice.value &&
              reStability == voiceStability.value &&
              reBoost == similarityBoost.value) {
            isTalking.value = !isTalking.value;
            await AllActions().playAutio(audioFile);
            isTalking.value = !isTalking.value;
          } else {
            isGeneratingVoice.value = !isGeneratingVoice.value;
            response = await getVoiceFromText(
                ELEVENLABS_API_KEY,
                TTS_OUTPUT,
                voiceMap[selectedVoice.value]!,
                voiceStability.value,
                similarityBoost.value);
            if (response != null) {
              //  print("Alaa is ${TTS_OUTPUT}");
              audioFile = await AllActions().saveTemp(response!);
              await onUserInfo();
              isGeneratingVoice.value = !isGeneratingVoice.value;
              isTalking.value = !isTalking.value;

              await AllActions().playAutio(audioFile);

              isTalking.value = !isTalking.value;
              text = TTS_OUTPUT;
              reselectedVoice = selectedVoice.value;
              reStability = voiceStability.value;
              reBoost = similarityBoost.value;
              print("Alaais${TTS_OUTPUT}");
            } else {
              isGeneratingVoice.value = !isGeneratingVoice.value;
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color(0xFF0A061C);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: GradientText(
          'Document Parser',
          gradient: ThemeManager.title,
          style: TextStyle(
            fontSize: LayoutManager.widthNHeight0(context, 1) * 0.05,
            fontFamily: ThemeManager.fontFamily,
          ),
          textAlign: TextAlign.right,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(
              () => ListDropDown(
                decoration2: BoxDecoration(),
                dropDownList: voiceList.value.toList(),
                onListSelect: onVoiceSelect,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: ThemeManager.background,
          ),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Container(
      decoration: BoxDecoration(color: Color(0xFF180D32)),
      child: DashChat(
        inputOptions: InputOptions(
            inputTextStyle: TextStyle(color: ThemeManager.dark),
            trailing: [
              IconButton(
                  onPressed: () {
                    _sendMediaMessage();
                    isGeminiTyping = true;
                  },
                  icon: const Icon(Icons.description, color: Colors.white)),
              IconButton(
                  onPressed: () {
                    _sendMediaMessageImage();
                    isGeminiTyping = true;
                  },
                  icon:
                      const Icon(Icons.image_search_sharp, color: Colors.white))
            ],
            leading: [
              Obx(
                () => GestureDetector(
                    onTap: onTextToVoice,
                    child: Stack(
                      children: [
                        isGeneratingVoice.value
                            ? Center(
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: ThemeManager.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [shadowGlow]),
                                  child: CircularProgressIndicator(
                                    color: ThemeManager.primary,
                                  ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  height: 30,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: ThemeManager.second,
                                      shape: BoxShape.circle,
                                      boxShadow: [shadowGlow]),
                                  child: Icon(
                                    Icons.multitrack_audio_rounded,
                                    color: ThemeManager.dark,
                                  ),
                                ),
                              ),
                      ],
                    )),
              ),
              SizedBox(width: LayoutManager.widthNHeight0(context, 1) * 0.02),
            ]),
        messageOptions: MessageOptions(
          textBeforeMedia: false,
          currentUserContainerColor: Color(0xFF180D32),
          currentUserTextColor: Color(0xFF180D32),
          containerColor: ThemeManager.second,
        ),
        currentUser: currentUser,
        typingUsers: isGeminiTyping ? [geminiUser] : [],
        onSend: (chatMessage) async {
          await _sendMessage(chatMessage);
          setState(() {
            imageCheck = false;
            isGeminiTyping = true;
          });
        },
        messages: messages,
      ),
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage,
      {bool hideInChat = false}) async {
    await _flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.ambient,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        IosTextToSpeechAudioCategoryOptions.duckOthers,
      ],
      IosTextToSpeechAudioMode.defaultMode,
    );
    TTS_OUTPUT = "";
    if (!hideInChat) {
      setState(() {
        messages = [chatMessage, ...messages];
      });
    }

    try {
      String question = chatMessage.text!;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }
      gemini.streamGenerateContent(question, images: images).listen(
        (event) {
          ChatMessage? lastMessage = messages.firstOrNull;
          if (lastMessage != null && lastMessage.user == geminiUser) {
            lastMessage = messages.removeAt(0);
            String response = event.content?.parts?.fold(
                    "", (previous, current) => "$previous ${current.text}") ??
                "";
            lastMessage.text += response;
            setState(() {
              messages = [lastMessage!, ...messages];
              isGeminiTyping = false;
            });
            print("+++++++++${response}");
            setState(() {
              TTS_OUTPUT += response;
            });
          } else {
            String response = event.content?.parts?.fold(
                    "", (previous, current) => "$previous ${current.text}") ??
                "";
            ChatMessage message = ChatMessage(
                user: geminiUser, createdAt: DateTime.now(), text: response);
            final regExp = RegExp(r'\*');

            response = response.replaceAll(regExp, '');
            setState(() {
              TTS_OUTPUT += response;
            });
            print("object +++++${TTS_OUTPUT}");

            setState(() {
              messages = [message, ...messages];

              isGeminiTyping = false;
            });
          }

          ;
        },
      );
    } catch (e) {
      print(e);
    }
  }

  List<ChatMessage> getGeminiSpacer() {
    return [
      ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: '\n',
      ),
    ];
  }

  Future<void> _sendMediaMessage() async {
    String Extraction_text = "";
    bool flag = true;
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      file = File(pickedFile.files.single.path!);

      try {
        Uint8List fileBytes = await _readDocumentData(file!.path);
        PdfDocument document = PdfDocument(inputBytes: fileBytes);
        PdfTextExtractor extractor = PdfTextExtractor(document);
        Extraction_text = extractor.extractText();
      } catch (e) {
        _showErrorDialog('Error', 'Failed to load the PDF document.');
      }
    } else {
      _showErrorDialog(
          'No File Selected', 'Please select a PDF file to upload.');
    }

    if (Extraction_text != "") {
      setState(() {
        imageCheck = true;
      });
      fileService.addFileText(FileTextModel(text: Extraction_text));
    } else {
      imageCheck = false;
      flag = false;
    }

    if (file != null && flag) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text:
            "I want you to be my data analyst and make a compelling storytelling based on the pdf provided and give me a conclusion.\n" +
                Extraction_text,
      );
      _sendMessage(chatMessage, hideInChat: true);
    }
  }

  Future<Uint8List> _readDocumentData(String filePath) async {
    try {
      File file = File(filePath);
      return await file.readAsBytes();
    } catch (e) {
      throw Exception('Failed to read file data: $e');
    }
  }

  void _showResult(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Extracted text'),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: Text(text),
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
              ),
            ),
          );
        });
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _sendMediaMessageImage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      setState(() {
        imageCheck = true;
      });

      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text:
            "I want you to be my data analyst and make a full compelling storytelling based on the image of the chart provided and give each part title.",
        medias: [
          ChatMedia(url: file.path, fileName: "", type: MediaType.image)
        ],
      );

      await _sendMessage(chatMessage);
    } else {
      _showErrorDialog(
          'No Image Selected', 'Please select an image to upload.');
    }
  }
}

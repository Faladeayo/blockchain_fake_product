import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/pointycastle.dart';

class FileEncryption extends StatefulWidget {
  @override
  _FileEncryptionState createState() => _FileEncryptionState();
}

class _FileEncryptionState extends State<FileEncryption> {
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>? _keyPair;
  String _publicKey = '';
  String _privateKey = '';
  String _encryptedFilePath = '';
  String _decryptedFilePath = '';

  Future<void> _generateKeyPair() async {
    final secureRandom = SecureRandom('Fortuna');
    final keyParams =
        RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 12);
    final keyGenerator = RSAKeyGenerator()
      ..init(ParametersWithRandom(keyParams, secureRandom));

    setState(() {
      _keyPair = keyGenerator.generateKeyPair()
          as AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>?;
      _publicKey =
          '${_keyPair!.publicKey.modulus}\n${_keyPair!.publicKey.exponent}';
      _privateKey =
          '${_keyPair!.privateKey.modulus}\n${_keyPair!.privateKey.exponent}';
    });
  }

  Future<void> _encryptFile(File file) async {
    final cipher = RSAEngine()
      ..init(true, PublicKeyParameter<RSAPublicKey>(_keyPair!.publicKey));
    final input = file.readAsBytesSync();
    final output = cipher.process(Uint8List.fromList(input));
    final encryptedFile = File('${file.path}.enc');
    await encryptedFile.writeAsBytes(output);
    setState(() {
      _encryptedFilePath = encryptedFile.path;
    });
  }

  Future<void> _decryptFile(File file) async {
    final cipher = RSAEngine()
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(_keyPair!.privateKey));
    final input = file.readAsBytesSync();
    final output = cipher.process(Uint8List.fromList(input));
    final decryptedFile = File('${file.path}.dec');
    await decryptedFile.writeAsBytes(output);
    setState(() {
      _decryptedFilePath = decryptedFile.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encrypt/Decrypt Files'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async => await _generateKeyPair(),
              child: Text('Generate Key Pair'),
            ),
            SizedBox(height: 16),
            Text('Public Key:\n$_publicKey'),
            SizedBox(height: 16),
            Text('Private Key:\n$_privateKey'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final filePickerResult =
                    await FilePicker.platform.pickFiles(type: FileType.any);
                if (filePickerResult != null) {
                  await _encryptFile(File(filePickerResult.files.single.path!));
                }
              },
              child: Text('Encrypt File'),
            ),
            SizedBox(height: 16),
            Text('Encrypted File Path:\n$_encryptedFilePath'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final filePickerResult =
                    await FilePicker.platform.pickFiles(type: FileType.any);
                if (filePickerResult != null) {
                  await _decryptFile(File(filePickerResult.files.single.path!));
                }
              },
              child: Text('Decrypt File'),
            ),
            SizedBox(height: 16),
            Text('Decrypted File Path:\n$_decryptedFilePath'),
          ],
        ),
      ),
    );
  }
}

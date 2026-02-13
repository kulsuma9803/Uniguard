

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();


  Future<XFile?> pickImageFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    return picked;
  }


  Future<XFile?> pickImageFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    return picked;
  }


  Future<String?> uploadImage(XFile imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final fileName =
          'img_${DateTime
          .now()
          .millisecondsSinceEpoch}${imageFile.name.substring(
          imageFile.name.lastIndexOf('.'))}';


      await Supabase.instance.client.storage
          .from('lost_images')
          .uploadBinary(fileName, bytes);


      final url = Supabase.instance.client.storage
          .from('lost_images')
          .getPublicUrl(fileName);

      return url;
    } catch (e) {
      print("Upload failed: $e");
      return null;
    }
  }


  Future<bool> deleteImage(String fileName) async {
    try {

      final removedFiles = await Supabase.instance.client.storage
          .from('lost_images')
          .remove([fileName]);


      if (removedFiles.isNotEmpty) {
        print("Deleted: ${removedFiles.first}");
        return true;
      } else {
        print("No file deleted");
        return false;
      }
    } catch (e) {
      print("Delete exception: $e");
      return false;
    }
  }
}
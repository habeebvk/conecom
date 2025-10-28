// Flutter FormPage widget
// Save this as form_page.dart and import into your app.
// Optional: to enable gallery/camera image picking, add to pubspec.yaml:
//   image_picker: ^1.0.0   (use the latest version from pub.dev)
// And add required permissions for Android/iOS as per image_picker docs.

import 'dart:io';

import 'package:ece/screens/cart_screen.dart';
import 'package:ece/screens/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _offerController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = {
        'item': _itemController.text.trim(),
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'offer': double.tryParse(_offerController.text) ?? 0.0,
        'stock': int.tryParse(_stockController.text) ?? 0,
        'description': _descriptionController.text.trim(),
        'imagePath': _imageFile?.path,
      };

      // Replace this with your saving logic (API call / database save)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved: ${data['item']} (price: ${data['price']})')),
      );
      // Optionally clear form
      // _formKey.currentState?.reset();
      // setState(() => _imageFile = null);
    }
  }

  @override
  void dispose() {
    _itemController.dispose();
    _priceController.dispose();
    _offerController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome Admin',style: GoogleFonts.poppins(fontWeight: FontWeight.w600),),
      actions: [
        IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
        }, icon: Icon(Icons.shopping_cart_sharp))
      ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 720, // max width for larger screens; will shrink on phones
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                      color: Colors.amberAccent
                    ),
                    child: Center(child: Text("Add Item",style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w400),))),
                  SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: TextFormField(
                      controller: _itemController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Item', border: OutlineInputBorder(gapPadding: 10,borderRadius: BorderRadius.all(Radius.circular(10)))),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter item name' : null,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20,right: 5),
                          child: TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder(gapPadding: 10,borderRadius: BorderRadius.all(Radius.circular(10)))),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Enter price';
                              if (double.tryParse(v) == null) return 'Enter valid number';
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5,right: 20),
                          child: TextFormField(
                            controller: _offerController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Offer Amount', border: OutlineInputBorder(gapPadding: 10,borderRadius: BorderRadius.all(Radius.circular(10)))),
                            validator: (v) {
                              if (v != null && v.trim().isNotEmpty && double.tryParse(v) == null) return 'Enter valid number';
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Stock', border: OutlineInputBorder(gapPadding: 10,borderRadius: BorderRadius.all(Radius.circular(10)))),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Enter stock count';
                        if (int.tryParse(v) == null) return 'Enter valid integer';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder(gapPadding: 10,borderRadius: BorderRadius.all(Radius.circular(10)))),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter description' : null,
                    ),
                  ),
                  SizedBox(height: 32,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10)
                            ),
                            maximumSize: Size(400, 60)
                          ),
                          onPressed:  (){Navigator.push(context, MaterialPageRoute(builder: (context) => ListDisplay()));},
                          child: Text('Save Item', style: GoogleFonts.poppins(fontSize: 16,color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

# village_visitor

 - Flutter basic widget.
 - Take picture.
 - Image crop and image draw.
 - Json to Dart object.
 - Get and Post Api.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Edit

### class BaseDataApi 
 - final String _host = "Your Host Name";

### class TakePictureScreenLicensePlate 
 - Map<String, String> get headers => {
        "Apikey": " Your API Key ",
        "Content-Type": "application/x-www-form-urlencoded",
      };

<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Automated Script Builder (Interaction Recorder) is a Flutter package to record all of user interaction in the app


## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

Include short and useful examples for package users. Add dependency
to `/pubspec.yaml` folder.

```dart
automated_script_builder:
    git:
      url: https://github.com/dzikrimutawakkil/interaction-recorder.git
```

In your manifest add this permission
```dart
    <!-- Media permissions for Android 13 and above -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
    <uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />

    <!-- Permissions for Android 9 and below (external storage access) -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

    <!-- Only use MANAGE_EXTERNAL_STORAGE if absolutely necessary for non-media files in Android 11+ -->
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
```

On Your Main App Function Add this
```dart
  await IInteractionRecorder().initInteractionRecorder();
```

## Usage
TextFIeld: To use in TextField doing like this

```dart
TextFormField(
  key: ValueKey("your_form_field_key"),
  onChanged: (text) => IInteractionRecorder()
      .logInteraction("Text input: $text", "your_form_field_key"),
  .....
```

Button: To use in Button or onTap Function doing like this

```dart
key: ValueKey("your_widget_key"),
onTap: () {
  IInteractionRecorder().logInteraction(
      "Button clicked", "your_widget_key");
}
```

## Additional information
Use Dependency Injection for use this package and use IInteractionRecorder as interface of InteractionRecorder. Your Logger file is on your Download directory folder on your phone and inside Logger Folder.

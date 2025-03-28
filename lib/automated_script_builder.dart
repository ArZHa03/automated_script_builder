import 'html_logger.dart' if (dart.library.io) 'io_logger.dart';
import 'iautomated_script_builder.dart';

class InteractionRecorder implements IInteractionRecorder {
  final logger = Logger();

  @override
  Future<void> logInteraction(String interaction, String key) async => await logger.logging(interaction, key);
  @override
  Future<void> initInteractionRecorder() async => await logger.init();
}

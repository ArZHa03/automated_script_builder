library automated_script_builder;

abstract class IInteractionRecorder {
  Future<void> logInteraction(String interaction, String key);
}

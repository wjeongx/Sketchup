require "sketchup.rb"
require "extensions.rb"

my_extension = SketchupExtension.new("My Plugin", "my_plugin/main.rb")
my_extension.description = "My first SketchUp plugin"
my_extension.version = "1.0"
my_extension.creator = "개발자명"

Sketchup.register_extension(my_extension, true)

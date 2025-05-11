require "sketchup.rb"

module MyPlugin
  def self.hello
    UI.messagebox("Hello, SketchUp!")
  end

  unless file_loaded?(__FILE__)
    UI.menu("Plugins").add_item("Say Hello") { self.hello }
    file_loaded(__FILE__)
  end
end

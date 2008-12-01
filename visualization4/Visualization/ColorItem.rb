module Visualization
  class ColorItem < Visualization::Item
    # colorは、Struct.new(:red, :green, :blue)で定義
    def initialize(color, area)
      super(color.to_s, colorToVector(color), area)
      @color = color
    end
    
    def colorToVector(c)
      color = { :red => c.red, :green => c.green, :blue => c.blue }
      Visualization::MultiVector.new(color)
    end
    
    def getColor
      @color
    end
  end
end

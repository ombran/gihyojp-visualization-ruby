module Visualization
  class Item
    include Visualization::Node
    
    # ノード作成
    # vectorはVisualization::MultiVectorオブジェクト
    def initialize(name, vector)
      @name = name
      @vector = vector
    end
    
    # ノード名取得
    def getName
      @name
    end
    
    # ベクトル取得
    def getVector
      @vector
    end
    
    def getVectors
      [@vector]
    end
  end
end

module Visualization
  class Item
    include Visualization::Node
    
    # ノード作成
    # vectorはVisualization::MultiVectorオブジェクト
    def initialize(name, vector, area)
      @name   = name
      @vector = vector
      @area   = area
    end
    
    # ノード名取得
    def getName
      @name
    end
    
    # ベクトル取得
    def getVector
      @vector
    end
    
    # ベクトル自身をリスト化して返す
    def getVectors
      [@vector]
    end
    
    def getArea
      @area
    end
  end
end

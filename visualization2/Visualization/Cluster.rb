module Visualization
  class Cluster
    include Visualization::Node
  
    # ノード作成
    # left,right共にVisualization::Itemオブジェクト
    def initialize(left, right)
      @left  = left
      @right = right
    end

    # 子ノード(左)取得
    def getLeft
      @left
    end

    # 子ノード(右)取得
    def getRight
      @right
    end
    
    def getVectors
      [@left.getVectors, @right.getVectors].flatten
    end
  end
end

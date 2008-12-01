module Visualization
  class ClusterBuilder
    # 指定された距離に基づいてビルダを作成
    # distanceEvaluatorはVisualization::DistanceEvaluatorオブジェクト
    def initialize(distanceEvaluator)
      @distanceEvaluator = distanceEvaluator
    end
    
    # クラスタリングを実行し、ノード階層を構築
    # nodesはVisualization::Itemオブジェクトの配列
    def build(nodes)
      # ノードが1つに集約されるまで繰り返す
      while(nodes.size > 1)
        puts nodes.size.to_s # 進行状況を表示
        merge1 = nil
        merge2 = nil
        minDist = Float::MAX
        # 距離が最小となるノード対を探す
        for i in 0..(nodes.size-1)
          n1 = nodes[i]
          for j in (i+1)..(nodes.size-1)
            n2 = nodes[j]
            dist = @distanceEvaluator.distance(n1, n2)
            if (dist < minDist)
              merge1 = n1
              merge2 = n2
              minDist = dist
            end
          end
        end
        # 次ステップ用のノードリスト作成
        nextNodes = []
        nodes.each do |node|
          if(node != merge1 && node != merge2)
            nextNodes << node
          end
        end
        # 統合対象のノード対をクラスタ化して追加
        nextNodes << Visualization::Cluster.new(merge1, merge2)
        nodes = nextNodes
      end
      return nodes[0]
    end
  end
end

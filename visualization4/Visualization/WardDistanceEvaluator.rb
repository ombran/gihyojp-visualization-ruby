module Visualization
  # Ward法に基づく距離関数の実装
  class WardDistanceEvaluator
    include Visualization::DistanceEvaluator
    
    def distance(n1, n2)
      s12 = sumCentroidDistanceSq(Visualization::Cluster.new(n1, n2))
      s1  = sumCentroidDistanceSq(n1)
      s2  = sumCentroidDistanceSq(n2)
      return s12 - (s1 + s2)
    end
    
    def sumCentroidDistanceSq(n)
      vectors = n.getVectors
      # ノードに含まれる全ベクトルの平均を計算
      center = Visualization::MultiVector.new
      vectors.each do |vector|
        center.add(vector)
      end
      center.divide(vectors.size)
      
      # ノードに含まれる各ベクトルと重心の距離の二乗の総和を計算
      sum = 0
      vectors.each do |vector|
        sum += vector.distanceSq(center)
      end
      return sum
    end
  end
end

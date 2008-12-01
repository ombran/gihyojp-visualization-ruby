module Visualization
  class NearestDistanceEvaluator
    include Visualization::DistanceEvaluator
    
    # n1, n2はVisualization::Nodeオブジェクト
    def distance(n1, n2)
      minDistSq = Float::MAX
      n1.getVectors.each do |v1|
        n2.getVectors.each do |v2|
          distSq = v1.distanceSq(v2)
          if(distSq < minDistSq)
            minDistSq = distSq
          end
        end
      end
      return Math.sqrt(minDistSq)
    end
  end
end

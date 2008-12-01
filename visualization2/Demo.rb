require File.dirname(__FILE__) + '/Visualization'

class Demo
  include Visualization

  def run
    # 入力データ作成
    input = []
    color = Struct.new(:red, :green, :blue)
    input << Item.new("BLUE",    colorToVector(color.new(0,   0,   255)))
    input << Item.new("CYAN",    colorToVector(color.new(0,   255, 255)))
    input << Item.new("MAGENTA", colorToVector(color.new(255, 0,   255)))
    input << Item.new("ORANGE",  colorToVector(color.new(255, 200, 0)))
    input << Item.new("PINK",    colorToVector(color.new(255, 175, 175)))
    input << Item.new("RED",     colorToVector(color.new(255, 0,   0)))
    
    # 最短距離法に基づく階層的クラスタリングを準備
    evaluator = NearestDistanceEvaluator.new
    builder = ClusterBuilder.new(evaluator)
    
    # クラスタリングを実行
    result = builder.build(input)
    
    # クラスタリング結果を表示
    output(result, 0)
  end
  
  def colorToVector(c)
    # 色成分を3次元のベクトルに変換
    MultiVector.new({:red => c.red, :green => c.green, :blue => c.blue})
  end

  def output(node, depth)
    # インデントを表示
    depth.times do
      print "    "
    end
    if (node.kind_of? Item)
      # 末端ノードなら項目名を表示
      puts node.getName
    elsif (node.kind_of? Cluster)
      # クラスタなら"+"を表示し、子ノードを再帰的に表示
      puts "+"
      cluster = node
      output(cluster.getLeft,  depth + 1)
      output(cluster.getRight, depth + 1)
    end
  end
end

demo = Demo.new
demo.run

require 'rubygems'
require 'RMagick'
require File.dirname(__FILE__) + '/Visualization'

class Demo
  include Visualization
  
  OUTPUT_FILE_NAME = 'treemap.png'
  
  def run
    color = Struct.new(:red, :green, :blue)
    # ランダムな色データを100個作成
    input = []
    100.times do |i|
      c = color.new(rand(256), rand(256), rand(256))
      area  = 0.2 + 0.8 * rand
      input << ColorItem.new(c, area)
    end
    
    # Ward法に基づく階層的クラスタリングを準備
    evaluator = WardDistanceEvaluator.new
    builder = ClusterBuilder.new(evaluator)
    
    # クラスタリングを実行
    puts "クラスタリング開始(結構時間かかります)"
    result = builder.build(input)
    puts "クラスタリング終了"
    
    # クラスタリング結果を表示
    puts "画像生成開始"
    output(result)
    puts "出力ファイル：" + OUTPUT_FILE_NAME
  end
  
  def output(node)
    # 400x400ピクセルの画像を作成
    g = Magick::Image.new(400, 400)
    
    # グラフィックオブジェクトを作成
    d = Magick::Draw.new
    
    # 背景を白で塗りつぶす
    d.fill("white")
    d.rectangle(0, 0, g.columns, g.rows)
    d.draw(g)

    # ツリーマップの描画を実行
    renderer = BinaryTreeMapRenderer.new
    bounds = Magick::Rectangle.new(360, 360, 20, 20)
    renderer.render(g, node, bounds)
    
    # 画像をPNGファイルに保存
    g.write(OUTPUT_FILE_NAME)
  end
end

demo = Demo.new
demo.run

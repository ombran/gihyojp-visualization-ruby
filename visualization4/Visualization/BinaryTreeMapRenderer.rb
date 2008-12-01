require 'rubygems'
require 'RMagick'

module Visualization
  #
  # 領域の2分割を再帰的に繰り返し、ツリーマップの描画を行う
  #
  class BinaryTreeMapRenderer
    include Visualization::TreeMapRenderer
    
    def render(graphic, node, bounds)
      doRender(graphic, node, bounds, 0)
    end
    
    def doRender(graphic, node, bounds, depth)
      d = Magick::Draw.new
      if (node.kind_of? Visualization::ColorItem)
        # ノードが色項目の場合は、その色で長方形を塗りつぶす
        d.fill("rgb(#{node.getVector.data[:red]}, #{node.getVector.data[:green]}, #{node.getVector.data[:blue]}, #{depth})")
        d.rectangle(bounds.x, bounds.y, bounds.x + bounds.width, bounds.y + bounds.height)
      elsif (node.kind_of? Visualization::Cluster)
        cluster = node
        
        # 子ノードchild1とchild2を取得
        child1 = cluster.getLeft
        child2 = cluster.getRight
        # child1の面積の方が大きくなるようにする
        if (child1.getArea < child2.getArea)
          temp = child1
          child1 = child2
          child2 = temp
        end
        
        # 子ノードの面積比を計算
        area1 = child1.getArea
        area2 = child2.getArea
        ratio1 = area1 / (area1 + area2)
        ratio2 = area2 / (area1 + area2)
        
        x = bounds.x
        y = bounds.y
        w = bounds.width
        h = bounds.height

        rect1 = nil
        rect2 = nil
        # 領域分割を実行
        if (w > h)
          # boundsが横長の場合、左右に分割
          rect1 = Magick::Rectangle.new(ratio1 * w, h, x, y)
          rect2 = Magick::Rectangle.new(ratio2 * w, h, x + ratio1 * w, y)
        else
          # boundsが縦長の場合、上下に分割
          rect1 = Magick::Rectangle.new(w, ratio1 * h, x, y)
          rect2 = Magick::Rectangle.new(w, ratio2 * h, x, y + ratio1 * h)
        end
        # 子ノードを再帰的に処理する
        doRender(graphic, child1, rect1, depth + 1)
        doRender(graphic, child2, rect2, depth + 1)
      end
    
      # 輪郭を階層の深さに応じた太さで描画
      d.fill("transparent")
      borderWidth = [8 - depth, 1].max
      d.stroke_width(borderWidth)
      d.stroke("black")
      d.rectangle(bounds.x, bounds.y, bounds.x + bounds.width, bounds.y + bounds.height)
      d.draw(graphic)
    end
  end
end

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
      if (node.kind_of? Visualization::BookmarkItem)
        item = node
        # 領域を塗りつぶす
        d.fill(bookmarkToColor(item))
        d.rectangle(bounds.x, bounds.y, bounds.x + bounds.width, bounds.y + bounds.height)
        
        # ブックマークタイトルを描画
        title = item.getBookmark.title
        drawStringWithin(d, title, bounds)

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
    
    # ブックマークノードを色に変換
    # @param item：ブックマークノード
    # @return：色
    def bookmarkToColor(item)
      detail = item.getDetail
      # コメント率を計算
      commentRate = detail.comments.size.to_f / detail.bookmarkCount.to_f
      # 補正をかける
      commentRate = [2 * commentRate, 1].min
      # コメント率からRGB要素を決定
      red   = 50 + (100 * commentRate).to_i
      green = 50 + (100 * (1 - commentRate)).to_i
      blue  = 50
      return "rgb(#{red}, #{green}, #{blue})"
    end
    
    # ブックマークされたエントリのタイトル
    def drawStringWithin(draw, title, rect)
      d = draw
      # フォントサイズ
      pointsize = [(Math.sqrt(rect.width * rect.height) / 10).to_i, 10].max
      # 日本語表示のためにフォント指定(環境によって変更してください)
      d.font = "/usr/share/fonts/truetype/kochi/kochi-gothic.ttf"
      # 文字色
      d.fill("white")
      d.stroke_width(0)
      d.pointsize(pointsize)
      
      # 文字を改行しながら出力
      words = [rect.width.to_f/pointsize.to_f, 1].max.to_i
      t_ary  = title.split("")
      t_size = t_ary.size
      rows = (t_size.to_f/words.to_f).ceil
      rows.times do |i|
        start  = i * words
        finish = ((i + 1) * words) - 1
        text = t_ary[start..finish].join
        y = rect.y + pointsize * (i + 1)
        d.text(rect.x + 5, y + 5, text)
      end
    end
  end
end

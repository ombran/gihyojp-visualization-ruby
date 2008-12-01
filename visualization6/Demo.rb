$KCODE = 'u'

require 'rubygems'
require 'RMagick'
require File.dirname(__FILE__) + '/Visualization'

class Demo
  include Visualization
  
  # 出力ファイル名
  OUTPUT_FILE_NAME = 'hatena_bookmark.png'
  
  def run
    api = HatenaBookmarkAPI.new
    bookmarks = api.getHotEntries
    puts bookmarks.size.to_s + " entries."
    
    # 階層的クラスタリングの入力データを作成
    input = []
    bookmarks.each do |bookmark|
      puts bookmark.title
      puts "  [url] " + bookmark.url
      # サーバの負荷を抑えるため呼び出し間隔を空ける
      sleep(1)
      detail = api.getDetail(bookmark.url)
      input << BookmarkItem.new(bookmark, detail)
      if (detail !=  nil)
        puts "  [bookmarkCount] " + detail.bookmarkCount.to_s
        puts "  [tags] [" + detail.tags.join(", ") + "]"
      end
    end
    
    # Ward法に基づく階層的クラスタリングを準備
    evaluator = Visualization::WardDistanceEvaluator.new
    builder = Visualization::ClusterBuilder.new(evaluator)
    
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
    # 出力画像を作成
    g = Magick::Image.new(1024, 768)
    
    # グラフィックオブジェクトを作成
    d = Magick::Draw.new
    
    # 背景を白で塗りつぶす
    d.fill("white")
    d.rectangle(0, 0, g.columns, g.rows)
    d.draw(g)

    # ツリーマップの描画を実行
    renderer = Visualization::BinaryTreeMapRenderer.new
    bounds = Magick::Rectangle.new(g.columns - 40, g.rows - 40, 20, 20)
    renderer.render(g, node, bounds)
    
    # 画像をPNGファイルに保存
    g.write(OUTPUT_FILE_NAME)
  end
end

demo = Demo.new
demo.run

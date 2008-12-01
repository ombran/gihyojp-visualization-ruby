require File.dirname(__FILE__) + '/Visualization'

class Demo
  include Visualization

  def run
    api = HatenaBookmarkAPI.new
    bookmarks = api.getHotEntries
    puts bookmarks.size.to_s + " entries."
    
    bookmarks.each do |bookmark|
      puts bookmark.title
      puts "  [url] " + bookmark.url
      # サーバの負荷を抑えるため呼び出し間隔を空ける
      sleep(1)
      detail = api.getDetail(bookmark.url)
      if (detail != nil)
        puts "  [bookmarkCount] " + detail.bookmarkCount.to_s
        puts "  [tags] [" + detail.tags.join(", ") + "]"
      end
    end
  end
end

demo = Demo.new
demo.run

module Visualization
  # はてなブックマークエントリに対応する末端ノード
  class BookmarkItem < Visualization::Item
    # @param bookmark：Visualization::Bookmarkオブジェクト
    # @param detail：Visualization::BookmarkDetailオブジェクト
    def initialize(bookmark, detail)
      # ブックマーク数をそのまま平均化すると比率が極端になるので
      # 平方根をとって調整する
      super(bookmark.title, tagsToVector(detail), Math.sqrt(detail.bookmarkCount))
      @bookmark = bookmark
      @detail = detail
    end
    
    def tagsToVector(detail)
      vector = Visualization::MultiVector.new
      detail.tags.each do |tag|
        vector.set(tag => (vector.get(tag).to_i + 1))
      end
      vector.normalize
      return vector
    end
    
    def getBookmark
      return @bookmark
    end
    
    def getDetail
      return @detail
    end
  end
end

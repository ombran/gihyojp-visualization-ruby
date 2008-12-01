module Visualization
  # ブックマークの詳細情報
  class BookmarkDetail
    attr_accessor :bookmarkCount # ブックマーク数
    attr_accessor :tags          # ブックマークに付与されたタグの一覧
    
    def initialize
      @bookmarkCount = nil
      @tags = []
    end
  end
end

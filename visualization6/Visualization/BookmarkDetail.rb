module Visualization
  # ブックマークの詳細情報
  class BookmarkDetail
    attr_accessor :bookmarkCount # ブックマーク数
    attr_accessor :tags          # ブックマークに付与されたタグの一覧
    attr_accessor :comments      # ブックマークに付与されたコメントの一覧
    
    def initialize
      @bookmarkCount = nil
      @tags = []
      @comments = []
    end
  end
end

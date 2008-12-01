require 'rss'
require 'open-uri'
require 'uri'

require 'rubygems'
require 'json'

module Visualization
  # はてなブックマークのAPIにアクセスするクラス
  class HatenaBookmarkAPI
    # 人気エントリーの情報を取得
    # @return：ブックマーク情報のリスト
    def getHotEntries
      bookmarks = []
      content = nil
      # 人気RSSフィードを読み込む
      open("http://b.hatena.ne.jp/hotentry.rss"){|u|
        content = u.read
      }
      rss = nil
      # RSSをParseする
      begin
        rss = RSS::Parser::parse(content)
      rescue RSS::InvalidRSSError
        rss = RSS::Parser::parse(content, false)
      end
      # 各エントリの情報を取得
      rss.items.each do |item|
        bookmark = Visualization::Bookmark.new
        bookmark.url   = item.link
        bookmark.title = item.title
        bookmarks << bookmark
      end
      return bookmarks
    end
    
    # ブックマークの詳細情報を取得
    # @param url：ブックマーク対象のURL
    # @return：詳細情報
    def getDetail(url)
      encodeUrl = URI.encode(url)
      # エントリ情報取得APIのURL
      apiUrl = "http://b.hatena.ne.jp/entry/json/?url=" + encodeUrl
      json = nil
      # URLを開き、データを読み込む
      open(apiUrl) do |f|
        # JSONをパース
        if f.read =~ /^\((.*)\)$/
          json = JSON.parse($1)
        end
      end

      # 詳細情報を作成
      detail = Visualization::BookmarkDetail.new
      detail.bookmarkCount = json["count"].to_i
      detail.tags = []
      detail.comments = []
      
      # bookmarks配列を読み込む
      bookmarks = json["bookmarks"]
      bookmarks.each do |item|
        # tags配列を読み込む
        tags = item["tags"]
        tags.each do |tag|
          detail.tags << tag
        end
        # comment要素を読み込む
        comment = item["comment"]
        if (comment != nil && comment.length > 0)
          detail.comments << comment
        end
      end
      
      return detail
    end
  end
end

module Visualization
  class MultiVector
    # ベクトル生成(引数はハッシュ)
    def initialize(hash={})
      @data = {}
      hash.each do |key, value|
        @data[key] = value
      end
    end

    def data
      @data
    end

    # ベクトルの次元を取得
    def dimension
      @data.length
    end

    # 指定されたキーに対応するベクトル成分を取得
    def get(key)
      @data[key]
    end
    
    # ベクトル成分を設定(引数はハッシュ)
    def set(hash)
      hash.each do |key, value|
        @data[key] = value
      end
    end
    
    # ベクトルのコピーを作成
    def copy
      dat = {}
      @data.each do |key, value|
        dat[key] = value
      end
      return Visualization::MultiVector.new(dat)
    end

    # 加算    
    def add(v)
      keys = (@data.keys + v.data.keys).flatten.uniq
      keys.each do |key|
        @data[key] = @data[key].to_f + v.data[key].to_f
      end
    end

    # 減算
    def subtract(v)
      keys = (@data.keys + v.data.keys).flatten.uniq
      keys.each do |key|
        @data[key] = @data[key].to_f - v.data[key].to_f
      end
    end
    
    # 定数倍
    def multiply(d)
      @data.each do |key, value|
        @data[key] *= d
      end
    end
    
    # 除算
    def divide(d)
      multiply(1.0 / d)
    end
    
    # ベクトルのノルム(長さ)
    def norm
      sum = 0
      @data.each do |key, value|
        d = value
        sum += d * d
      end
      return Math.sqrt(sum)
    end
    
    # ベクトルを正規化
    def normalize
      divide(norm)
    end
    
    # 指定されたベクトルとの距離の二乗を取得
    def distanceSq(v)
      sum = 0
      keys = (@data.keys + v.data.keys).flatten.uniq
      keys.each do |key|
        d = v.data[key].to_f - @data[key].to_f
        sum += d * d
      end
      return sum
    end
  end
end

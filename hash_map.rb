

class HashMap
  attr_accessor :capacity, :load_factor, :size, :buckets
  def initialize(capacity = 16, load_factor = 0.75)
    @capacity = capacity
    @load_factor = load_factor
    @size = 0
    @buckets = Array.new(capacity) { [] }
  end

  def hash(key)
    hash_code = 0
    random_prime = 31
    key.to_s.each_char { |char| hash_code = random_prime * hash_code + char.ord }

    hash_code
  end

  def set(key, value)
    key_hash = hash(key) % @capacity
    bucket = @buckets[key_hash]
    bucket.each do |pair|
      if pair[0] == key
        pair[1] = value
        return
      end
    end

    bucket << [key, value]
    @size += 1
    
    resize if @size > @capacity * @load_factor
  end

  def get(key)
    key_hash = hash(key) % @capacity
    bucket = @buckets[key_hash]
    bucket.each do |pair|
      return pair[1] if pair[0] == key
    end
  end

  def has?(key)
    key_hash = hash(key) % @capacity
    bucket = @buckets[key_hash]
    bucket.each do |pair|
      return true if pair[0] == key
    end
    false
  end

  def remove(key)
    key_hash = hash(key) % @capacity
    bucket = @buckets[key_hash]
    bucket.each_with_index do |pair, index|
      if pair[0] == key
        bucket.delete_at(index)
        @size -= 1
        return pair[1]
      end
    end
    nil
  end

  def length
    @size
  end

  def clear
    @capacity = 16
    @buckets = Array.new(@capacity) { [] }
    @size = 0
    nil
  end

  def keys
    @buckets.flat_map do |bucket|
      bucket.map { |pair| pair[0] }
    end
  end

  def values
    @buckets.flat_map do |bucket|
      bucket.map { |pair| pair[1] }
    end
  end

  def entries
    @buckets.flatten(1)
  end

  def resize
    @capacity *= 2
    new_buckets = Array.new(@capacity) { [] }
    @buckets.each do |bucket|
      bucket.each do |key, value|
        new_key_hash = hash(key) % @capacity
        new_buckets[new_key_hash] << [key, value]
      end
    end
    @buckets = new_buckets
  end

end

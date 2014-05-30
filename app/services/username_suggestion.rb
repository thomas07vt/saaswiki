class UsernameSuggestion

  def self.terms_for(prefix)
    $redis.zrange "search-suggestions:#{prefix.downcase}", 0, 9
  end

  def self.index_products
    User.all.pluck(:username).each do |username|
      index_term(username)
    end
  end

  def self.index_term(term)
    1.upto(term.length - 1) do |n|
      prefix = term[0, n]
      $redis.zadd "search-suggestions:#{prefix.downcase}", 1, term.downcase
    end
  end

end
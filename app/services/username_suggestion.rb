class UsernameSuggestion

  def self.terms_for(prefix)
    suggestions = User.where("username like ?", "#{prefix}%")
    suggestions.order("username asc").limit(10).pluck(:username)
  end

end
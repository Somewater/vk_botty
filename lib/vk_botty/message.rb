module VkBotty

  # abstract message (including posts, comments and private messages)
  class Message
    # @return [String]
    attr_accessor :text

    # @return [Time]
    attr_accessor :created_at

    # @return [User]
    attr_accessor :author

    def self.create author, text
      m = Message.new
      m.text = text
      m.author = author
      m
    end

    def to_s
      "#{self.class.to_s}<author=#{author}, text=\"#{text[0..20]}\">"
    end
  end
end
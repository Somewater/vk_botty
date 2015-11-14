module VkBotty

  # Abstract class for each place with user generated content (user wall, group wall)
  # This entity can lazy download this content
  class PublicationHost
    attr_reader :backend

    attr_accessor :id

    def initialize backend
      @backend = backend
    end
  end
end

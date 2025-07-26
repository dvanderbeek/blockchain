module Blockchain
  class Status
    attr_reader :name

    def initialize(name)
      @name = name
    end

    PENDING   = new(:pending)
    CONFIRMED = new(:confirmed)
    FAILED    = new(:failed)
    EXPIRED   = new(:expired)

    ALL = [PENDING, CONFIRMED, FAILED, EXPIRED].freeze
    TERMINAL = [CONFIRMED, FAILED, EXPIRED].freeze

    def terminal?
      TERMINAL.map(&:name).include?(name)
    end

    def ==(other)
      other.is_a?(Status) && name == other.name
    end

    alias eql? ==

    def hash
      name.hash
    end

    def to_s
      name.to_s
    end

    def inspect
      "#<#{self.class} #{name}>"
    end
  end
end

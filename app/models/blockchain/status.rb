module Blockchain
  class Status
    attr_reader :name

    def initialize(name)
      @name = name
    end

    PENDING   = new(:pending)
    CONFIRMED = new(:confirmed)
    FAILED    = new(:failed)
    DROPPED   = new(:dropped)
    REPLACED  = new(:replaced)

    ALL = [PENDING, CONFIRMED, FAILED, DROPPED, REPLACED].freeze
    TERMINAL = [CONFIRMED, FAILED, DROPPED, REPLACED].freeze

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

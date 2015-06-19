module IceCube

  class StringBuilder

    attr_writer :base

    def initialize
      @types = {}
    end

    def piece(type, prefix = nil, suffix = nil)
      @types[type] ||= []
    end

    def to_s
      @types.each_with_object(@base || '') do |(type, segments), str|
        if f = self.class.formatter(type)
          str << ' ' << f.call(segments)
        else
          next if segments.empty?
          str << ' ' << self.class.sentence(segments)
        end
      end
    end

    def self.formatter(type)
      @formatters[type]
    end

    def self.register_formatter(type, &formatter)
      @formatters ||= {}
      @formatters[type] = formatter
    end

    module Helpers

      NUMBER_SUFFIX = ['th', 'st', 'nd', 'rd', 'th', 'th', 'th', 'th', 'th', 'th']
      SPECIAL_SUFFIX = { 11 => 'th', 12 => 'th', 13 => 'th', 14 => 'th' }

      # influenced by ActiveSupport's to_sentence
      def sentence(array)
        case array.length
        when 0 ; ''
        when 1 ; array[0].to_s
        when 2 ; "#{array[0]} 和 #{array[1]}"
        else ; "#{array[0...-1].join(', ')}, 和 #{array[-1]}"
        end
      end

      def nice_number(number)
        return '最后一' if number == -1
        suffix = number
        if number < -1
          number.abs.to_s << suffix << '最后一'
        else
          number.to_s << suffix
        end
      end

    end

    extend Helpers

  end

end

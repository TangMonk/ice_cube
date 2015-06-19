module IceCube

  module Validations::SecondOfMinute

    def second_of_minute(*seconds)
      seconds.flatten.each do |second|
      unless second.is_a?(Fixnum)
        raise ArgumentError, "Expecting Fixnum value for second, got #{second.inspect}"
      end
        validations_for(:second_of_minute) << Validation.new(second)
      end
      clobber_base_validations :sec
      self
    end

    class Validation < Validations::FixedValue

      attr_reader :second
      alias :value :second

      def initialize(second)
        @second = second
      end

      def type
        :sec
      end

      def dst_adjust?
        false
      end

      def build_s(builder)
        builder.piece(:second_of_minute) << StringBuilder.nice_number(second)
      end

      def build_hash(builder)
        builder.validations_array(:second_of_minute) << second
      end

      def build_ical(builder)
        builder['BYSECOND'] << second
      end

      StringBuilder.register_formatter(:second_of_minute) do |segments|
        str = "在每分钟的第 #{StringBuilder.sentence(segments)} "
        str << (segments.size == 1 ? '秒' : '秒')
      end

    end

  end

end

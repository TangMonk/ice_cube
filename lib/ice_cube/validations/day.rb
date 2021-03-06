require 'date'

module IceCube

  module Validations::Day

    def day(*days)
      days.flatten.each do |day|
        unless day.is_a?(Fixnum) || day.is_a?(Symbol)
          raise ArgumentError, "expecting Fixnum or Symbol value for day, got #{day.inspect}"
        end
        day = TimeUtil.sym_to_wday(day)
        validations_for(:day) << Validation.new(day)
      end
      clobber_base_validations(:wday, :day)
      self
    end

    class Validation < Validations::FixedValue

      attr_reader :day
      alias :value :day

      def initialize(day)
        @day = day
      end

      def type
        :wday
      end

      def dst_adjust?
        true
      end

      def build_s(builder)
        builder.piece(:day) << day
      end

      def build_hash(builder)
        builder.validations_array(:day) << day
      end

      def build_ical(builder)
        ical_day = IcalBuilder.fixnum_to_ical_day(day)
        # Only add if there aren't others from day_of_week that override
        if builder['BYDAY'].none? { |b| b.end_with?(ical_day) }
          builder['BYDAY'] << ical_day
        end
      end

      StringBuilder.register_formatter(:day) do |validation_days|
        segments = validation_days.map { |d| I18n.t("date.day_names")[d] }
        "的 #{StringBuilder.sentence(segments)}"
      end

    end

  end

end

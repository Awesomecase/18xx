# frozen_string_literal: true

require_relative 'base'
require_relative 'revenue_center'

module Engine
  module Part
    class Offboard < Base
      include Part::RevenueCenter

      def initialize(revenue)
        @revenue = parse_revenue(revenue)
      end

      def offboard?
        true
      end
    end
  end
end

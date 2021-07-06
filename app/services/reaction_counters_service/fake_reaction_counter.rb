# frozen_string_literal: true

module ReactionCountersService
  class FakeReactionCounter
    ATTRIBUTES = %i(reactions_count character)

    def initialize(attributes)
      @attributes = attributes
    end

    ATTRIBUTES.each do |attr|
      define_method attr do
        @attributes[attr]
      end
    end
  end
end

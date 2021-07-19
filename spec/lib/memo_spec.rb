# frozen_string_literal: true

require "rails_helper"

class ExampleMemoClass
  include Memo
  attr_reader :value
  def initialize
    @value = 0
  end

  def count
    memo(:@count) do
      @value += 1
    end
  end
end

RSpec.describe Memo do
  subject do
    ExampleMemoClass.new
  end

  it "returns" do
    expect(subject.count).to eq(1)
    expect(subject.count).to eq(1)
  end
end

# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Layout::MultilineMethodDefinitionBraceLayout, :config do
  let(:cop_config) { { 'EnforcedStyle' => 'symmetrical' } }

  it 'ignores implicit defs' do
    expect_no_offenses(<<~RUBY)
      def foo a: 1,
      b: 2
      end
    RUBY
  end

  it 'ignores single-line defs' do
    expect_no_offenses(<<~RUBY)
      def foo(a,b)
      end
    RUBY
  end

  it 'ignores defs without params' do
    expect_no_offenses(<<~RUBY)
      def foo
      end
    RUBY
  end

  include_examples 'multiline literal brace layout' do
    let(:prefix) { 'def foo' }
    let(:suffix) { 'end' }
    let(:open) { '(' }
    let(:close) { ')' }
    let(:multi_prefix) { 'b: ' }
  end
end

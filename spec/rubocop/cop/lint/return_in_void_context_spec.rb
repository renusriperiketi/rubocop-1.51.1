# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Lint::ReturnInVoidContext, :config do
  context 'with an initialize method containing a return with a value' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class A
          def initialize
            return :qux if bar?
            ^^^^^^ Do not return a value in `initialize`.
          end
        end
      RUBY
    end
  end

  context 'with an initialize method containing a return without a value' do
    it 'accepts' do
      expect_no_offenses(<<~RUBY)
        class A
          def initialize
            return if bar?
          end
        end
      RUBY
    end
  end

  context 'with a setter method containing a return with a value' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class A
          def foo=(bar)
            return 42
            ^^^^^^ Do not return a value in `foo=`.
          end
        end
      RUBY
    end
  end

  context 'with a setter method containing a return without a value' do
    it 'accepts' do
      expect_no_offenses(<<~RUBY)
        class A
          def foo=(bar)
            return
          end
        end
      RUBY
    end
  end

  context 'with a non initialize method containing a return' do
    it 'accepts' do
      expect_no_offenses(<<~RUBY)
        class A
          def bar
            foo
            return :qux if bar?
            foo
          end
        end
      RUBY
    end
  end

  context 'with a class method called initialize containing a return' do
    it 'accepts' do
      expect_no_offenses(<<~RUBY)
        class A
          def self.initialize
            foo
            return :qux if bar?
            foo
          end
        end
      RUBY
    end
  end

  context 'when return is in top scope' do
    it 'accepts' do
      expect_no_offenses(<<~RUBY)
        return if true
      RUBY
    end
  end
end

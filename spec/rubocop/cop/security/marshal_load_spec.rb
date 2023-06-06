# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Security::MarshalLoad, :config do
  it 'registers an offense for using Marshal.load' do
    expect_offense(<<~RUBY)
      Marshal.load('{}')
              ^^^^ Avoid using `Marshal.load`.
      ::Marshal.load('{}')
                ^^^^ Avoid using `Marshal.load`.
    RUBY
  end

  it 'registers an offense for using Marshal.restore' do
    expect_offense(<<~RUBY)
      Marshal.restore('{}')
              ^^^^^^^ Avoid using `Marshal.restore`.
      ::Marshal.restore('{}')
                ^^^^^^^ Avoid using `Marshal.restore`.
    RUBY
  end

  it 'does not register an offense for Marshal.dump' do
    expect_no_offenses(<<~RUBY)
      Marshal.dump({})
      ::Marshal.dump({})
    RUBY
  end

  it 'does not register an offense Marshal methods under another namespace' do
    expect_no_offenses(<<~RUBY)
      SomeNamespace::Marshal.load('')
      SomeNamespace::Marshal.restore('')
      SomeNamespace::Marshal.dump('')
      ::SomeNamespace::Marshal.load('')
      ::SomeNamespace::Marshal.restore('')
      ::SomeNamespace::Marshal.dump('')
    RUBY
  end

  it 'allows using dangerous Marshal methods for deep cloning' do
    expect_no_offenses(<<~RUBY)
      Marshal.load(Marshal.dump({}))
      Marshal.restore(Marshal.dump({}))
    RUBY
  end
end

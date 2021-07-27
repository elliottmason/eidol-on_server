# frozen_string_literal: true

# Abstract service that wraps #perform in callbacks
class ApplicationService
  include ActiveSupport::Callbacks

  define_callbacks :perform
  define_callbacks :failure

  class << self
    def with(*args)
      new(*args).tap(&:perform_with_callbacks)
    end

    alias between with

    alias for with

    alias now with

    def after_perform(*args, &block)
      return set_callback(:perform, :after, &block) if block_given?
      set_callback :perform, :after, *args
    end

    def before_perform(*args, &block)
      return set_callback(:perform, :before, &block) if block_given?
      set_callback :perform, :before, *args
    end
  end

  def perform_with_callbacks
    run_callbacks :perform do
      break unless allowed?

      perform
    end

    after_failure unless successful?
  end

  def allowed?
    true
  end

  def initialize(*_args); end

  def perform; end

  def successful?
    @successful || false
  end

  def after_failure; end

  def after_success; end
end

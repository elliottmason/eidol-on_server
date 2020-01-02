# frozen_string_literal: true

# Abstract service that wraps #perform in callbacks
class ApplicationService
  include ActiveSupport::Callbacks

  define_callbacks :perform
  define_callbacks :failure

  class << self
    # @return [self]
    def with(*args)
      new(*args).tap(&:perform_with_callbacks)
    end

    # @return [self]
    alias between with

    # @return [self]
    alias for with

    # @return [self]
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

  # @!method self.for()
  #   @return [ApplicationService]

  # @return [void]
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

  # @return [void]
  def perform; end

  def successful?
    @successful || false
  end

  # @return [void]
  def after_failure; end

  # @return [void]
  def after_success; end
end

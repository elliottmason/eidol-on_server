# frozen_string_literal: true

# Abstract service that wraps #perform in callbacks
class ApplicationService
  include ActiveSupport::Callbacks

  define_callbacks :perform

  class << self
    # @return [self]
    def with(*args)
      new(*args).tap(&:_perform)
    end

    # @return [self]
    alias between with

    # @return [self]
    alias for with

    # @return [self]
    alias now with
  end

  # @return [void]
  def _perform
    run_callbacks :perform do
      return unless allowed?

      perform
    end
    after_failure unless successful?
  end

  # @return [void]
  def after_failure; end

  def allowed?
    true
  end

  def initialize(*_args); end

  # @return [void]
  def perform; end

  def successful?
    @successful || false
  end
end

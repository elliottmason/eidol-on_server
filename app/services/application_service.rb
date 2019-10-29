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

    # @!method for()
    #   @return [ApplicationService]
  end

  # @return [void]
  def _perform
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
end

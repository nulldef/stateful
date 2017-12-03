module Statum
  # Class for storing event info
  class Event
    attr_reader :from, :to

    # Creates an event class
    #
    # @param [String|Symbol] from From state name
    # @param [String|Symbol] to To state name
    # @param [Hash] options Options for event
    def initialize(from, to, options = {})
      @from   = from
      @to     = to
      @before = options.fetch(:before, nil)
      @after  = options.fetch(:after, nil)
    end

    # Returns before hook
    #
    # @param [Object] instance Instance of class
    #
    # @return [Method]
    def before(instance)
      hook(instance, @before) unless @before.nil?
    end

    # Returns after hook
    #
    # @param [Object] instance Instance of class
    #
    # @return [Method]
    def after(instance)
      hook(instance, @after) unless @after.nil?
    end

    # Returns true if event can be fired from current state
    #
    # @param [String|Symbol] current_state Current state
    #
    # @return [Boolean]
    def can_fire?(current_state)
      if from.is_a?(Array)
        from.include?(current_state.to_sym)
      elsif from == :__statum_any_state
        true
      else
        from == current_state.to_sym
      end
    end

    # Check if before hook exists
    #
    # @param [Object] instance Instance of class
    #
    # @return [boolean]
    def before?(instance)
      !before(instance).nil?
    end

    # Checks if after hook present
    #
    # @param [Object] instance Instance of class
    #
    # @return [boolean]
    def after?(instance)
      !after(instance).nil?
    end

    private

    def hook(instance, hook)
      hook.is_a?(Symbol) ? instance.method(hook) : hook.to_proc unless hook.nil?
    end
  end
end

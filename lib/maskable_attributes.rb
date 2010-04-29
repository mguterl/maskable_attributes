module MaskableAttributes

  class << self
    attr_accessor :default_masking
  end

  DEFAULT_MASKING = "************"

  self.default_masking = DEFAULT_MASKING

  def self.strategies
    @strategies ||= {}
  end

  strategies[:stars] = lambda { |v| "*" * v.size }

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def masked_attributes(*attributes)
      options = attributes.last.is_a?(::Hash) ? attributes.pop : {}

      attributes.each do |attribute|
        define_method(attribute) do
          if with = options[:with]
            with = MaskableAttributes.strategies[with] if MaskableAttributes.strategies[with]
            if with.respond_to?(:call)
              if value = super
                with.call(value)
              else
                nil
              end
            else
              with
            end
          else
            MaskableAttributes.default_masking
          end
        end
      end
    end

  end

end

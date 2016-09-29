# require 'procedo/engine/intervention/product_parameter'

module Procedo
  module Engine
    class Intervention
      class Output < Procedo::Engine::Intervention::Quantified
        attr_reader :variant

        attr_reader :new_name, :variety, :derivative_of

        def initialize(intervention, id, attributes = {})
          super(intervention, id, attributes)
          if @attributes[:variant_id].present?
            @variant = ProductNatureVariant.find_by(id: @attributes[:variant_id])
          end
          @new_name = @attributes[:new_name]
          @variety = @attributes[:variety]
          @derivative_of = @attributes[:derivative_of]
        end

        def variant_id
          @variant ? @variant.id : nil
        end

        def variant=(record)
          self.variant_id = record.id
        end

        def variant_id=(id)
          @variant = ProductNatureVariant.find_by(id: id)
          impact_dependencies!(:variant)
        end

        def new_name=(name)
          @new_name = name
          impact_dependencies!(:new_name)
        end

        def variety=(value)
          unless value.blank? || Nomen::Variety.find(value)
            raise 'Invalid variety: ' + value.inspect
          end
          @variety = value
          impact_dependencies!(:variety)
        end

        def derivative_of=(value)
          unless value.blank? || Nomen::Variety.find(value)
            raise 'Invalid derivative_of: ' + value.inspect
          end
          @derivative_of = value
          impact_dependencies!(:derivative_of)
        end

        def to_hash
          hash = super
          hash[:variant_id] = @variant.id if @variant
          hash[:new_name] = @new_name unless @new_name.blank?
          hash[:variety] = @variety unless @variety.blank?
          hash[:derivative_of] = @derivative_of unless @derivative_of.blank?
          hash
        end

        def env
          super.merge(variant: variant, new_name: new_name, variety: variety, derivative_of: derivative_of)
        end
      end
    end
  end
end

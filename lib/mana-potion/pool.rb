require 'mana-potion/check_usage'

module ManaPotion
  module Pool
    def self.included(other)
      other.extend ClassMethods
    end

    module ClassMethods
      def mana_pool_for(association, limit: 1, period: 1.day)
        before_validation do
          limit = instance_exec &limit if limit.respond_to?(:call)
          period = instance_exec &period if period.respond_to?(:call)

          check_usage = ManaPotion::CheckUsage.new(self, send(association), limit, period)
          if check_usage.exceeded?
            errors.add(association, :limit, limit: limit, count: check_usage.count)
          end
        end
      end
    end
  end
end

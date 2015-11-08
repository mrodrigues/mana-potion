require 'mana-potion/check_usage'

module ManaPotion
  module Pool
    class MissingOwnerError < StandardError; end

    def self.included(other)
      other.extend ClassMethods
    end

    module ClassMethods
      def mana_pool_for(association, limit: 1, period: 1.day, allow_nil: false)
        before_validation do
          owner = send(association)

          if owner.nil?
            raise MissingOwnerError, "#{self.class.name} it's missing its #{association}. If you want to allow that, include the allow_nil: true option in your Pool configuration." unless allow_nil
            next
          end

          limit = instance_exec &limit if limit.respond_to?(:call)
          period = instance_exec &period if period.respond_to?(:call)

          check_usage = ManaPotion::CheckUsage.new(self, owner, limit, period)
          if check_usage.exceeded?
            errors.add(association, :limit, limit: limit, count: check_usage.count)
          end
        end
      end
    end
  end
end

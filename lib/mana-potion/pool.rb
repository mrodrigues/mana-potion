module ManaPotion
  module Pool
    def self.included(other)
      other.extend ClassMethods
    end

    module ClassMethods
      def spends_mana_for(association, limit: 1, period: -> { 1.day.ago..Time.current })
        before_validation do
          owner = send(association)
          other_side_association = owner
          .class
          .reflect_on_all_associations
          .detect { |r| r.class_name == self.class.name }

          count = owner
          .send(other_side_association.name)
          .where(created_at: period.call)
          .count

          if count >= limit
            errors.add(association, :limit, limit: limit, count: count)
          end
        end
      end
    end
  end
end

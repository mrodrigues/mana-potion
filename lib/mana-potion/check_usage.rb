module ManaPotion
  class CheckUsage
    attr_reader :model, :owner, :limit, :period

    def initialize(model, owner, limit, period)
      @model = model
      @owner = owner
      @limit = limit
      @period = period
    end

    def exceeded?
      count >= limit
    end

    def remaining
      limit - count
    end

    def association
      owner
      .class
      .reflect_on_all_associations
      .detect { |r| r.class_name == model.class.name }
    end

    def count
      owner
      .send(association.name)
      .where(created_at: period.ago..Time.current)
      .count
    end
  end
end

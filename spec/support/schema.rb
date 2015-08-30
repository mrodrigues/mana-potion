ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.integer  :mana
    t.timestamps null: false
  end

  create_table :posts, :force => true do |t|
    t.integer  :user_id
    t.timestamps null: false
  end
end

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.string   :name
    t.timestamps null: false
  end

  create_table :posts, :force => true do |t|
    t.string   :title
    t.integer  :user_id
    t.timestamps null: false
  end
end

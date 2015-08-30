require 'spec_helper'
require 'mana-potion/pool'

describe ManaPotion::Pool do
  before do
    @user = User.create!
    @post = @user.posts.create!
    Post.send :include, ManaPotion::Pool
  end

  after do
    Post.reset_callbacks(:validation)
    Timecop.return
  end

  it 'limits posts creation by time limit' do
    Post.mana_pool_for :user

    expect { @user.posts.create! }.to raise_error(ActiveRecord::RecordInvalid)
    Timecop.travel 1.day.from_now
    expect { @user.posts.create! }.not_to raise_error
  end

  it 'allows configuring the limit' do
    Post.mana_pool_for :user, limit: 2

    expect { @user.posts.create! }.not_to raise_error
    expect { @user.posts.create! }.to raise_error(ActiveRecord::RecordInvalid)
    Timecop.travel 1.day.from_now
    expect { @user.posts.create! }.not_to raise_error
  end

  it 'allows configuring the limit with a proc' do
    class Post
      mana_pool_for :user, limit: -> { limit }

      def limit
        2
      end
    end

    expect { @user.posts.create! }.not_to raise_error
    expect { @user.posts.create! }.to raise_error(ActiveRecord::RecordInvalid)
    Timecop.travel 1.day.from_now
    expect { @user.posts.create! }.not_to raise_error
  end

  it 'allows configuring the period' do
    Post.mana_pool_for :user, period: 1.hour

    expect { @user.posts.create! }.to raise_error(ActiveRecord::RecordInvalid)
    Timecop.travel 1.hour.from_now
    expect { @user.posts.create! }.not_to raise_error
  end

  it 'allows configuring the period with a proc' do
    class Post
      mana_pool_for :user, period: -> { period }

      def period
        1.hour
      end
    end

    expect { @user.posts.create! }.to raise_error(ActiveRecord::RecordInvalid)
    Timecop.travel 1.hour.from_now
    expect { @user.posts.create! }.not_to raise_error
  end
end

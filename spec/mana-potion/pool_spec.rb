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
  end

  it 'limits posts creation by time limit' do
    Post.spends_mana_for :user

    expect { @user.posts.create! }.to raise_error(ActiveRecord::RecordInvalid)
    Timecop.travel 1.day.from_now
    expect { @user.posts.create! }.not_to raise_error
  end

  it 'allows configuring the limit' do
    Post.spends_mana_for :user, limit: 2

    expect { @user.posts.create! }.not_to raise_error
    expect { @user.posts.create! }.to raise_error(ActiveRecord::RecordInvalid)
    Timecop.travel 1.day.from_now
    expect { @user.posts.create! }.not_to raise_error
  end

  it 'allows configuring the period' do
    Post.spends_mana_for :user, period: -> { 1.hour.ago..Time.current }

    expect { @user.posts.create! }.to raise_error(ActiveRecord::RecordInvalid)
    Timecop.travel 1.hour.from_now
    expect { @user.posts.create! }.not_to raise_error
  end
end

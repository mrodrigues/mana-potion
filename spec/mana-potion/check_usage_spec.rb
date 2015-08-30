require 'spec_helper'

describe ManaPotion::CheckUsage do
  before do
    @user = User.create!
    @user.posts.create!
  end

  context "exceeded limit" do
    let(:check_usage) { ManaPotion::CheckUsage.new(Post.new, @user, 1, 1.hour) }

    it { expect(check_usage.remaining).to be 0 }
    it { expect(check_usage.count).to be 1 }
    it { expect(check_usage.exceeded?).to be true }

    it "after period" do
      Timecop.travel 1.hour.from_now
      expect(check_usage.exceeded?).to be false
      Timecop.return
    end
  end

  context "didn't exceed" do
    let(:check_usage) { ManaPotion::CheckUsage.new(Post.new, @user, 3, 1.hour) }

    it { expect(check_usage.remaining).to be 2 }
    it { expect(check_usage.count).to be 1 }
    it { expect(check_usage.exceeded?).to be false }
  end
end

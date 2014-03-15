# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Relationship do
	before(:each) do
		@follower = FactoryGirl.create(:user)
		@followed = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
		@attr = { :followed_id => @followed.id }
	end

	it "should create a new instance with valid attributes" do
		@follower.relationships.create!(@attr)
	end

	describe "follow methods" do
		before(:each) do
			@relationship = @follower.relationships.create!(@attr)
		end

		it "should have a follower atribute" do
			@relationship.should respond_to(:follower)
		end

		it "should have the right follower" do
			@relationship.follower.should == @follower
		end
		it "should have a followed atribute" do
			@relationship.should respond_to(:followed)
		end

		it "should have the right followed" do
			@relationship.followed.should == @followed
		end
	end

	describe "validations" do
		it "should require a follower id " do
			Relationship.new(@attr).should_not be_valid
		end

		it "should require a followed id" do
			@follower.relationships.build.should_not be_valid
		end

	end
end

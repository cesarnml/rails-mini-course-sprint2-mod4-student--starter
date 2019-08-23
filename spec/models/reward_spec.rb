require "rails_helper"

RSpec.describe Reward, type: :model do
  describe "validations" do
    it "is valid" do
      reward = Reward.new(cost: 50, name: "Cool Reward")

      result = reward.valid?
      errors = reward.errors.full_messages

      expect(result).to be true
      expect(errors).to be_empty
    end
    it "is invalid without a cost" do
      reward = Reward.new(name: "Another Reward", cost: nil)

      result = reward.valid?
      errors = reward.errors.full_messages

      expect(result).to be false
      expect(errors).to include("Cost can't be blank")
    end

    it "is invalid without a name" do
      reward = Reward.new(cost: 50, name: nil)

      result = reward.valid?
      errors = reward.errors.full_messages

      expect(result).to be false
      expect(errors).to include("Name can't be blank")
    end
  end

  describe "attributes" do
    it "has expected attributes" do
      reward = Reward.new(cost: 50, name: "Cool Reward")

      result = reward.attribute_names.map(&:to_sym)

      expect(result).to contain_exactly(
        :cost,
        :created_at,
        :deactivated_at,
        :id,
        :inventory,
        :name,
        :purchase_count,
        :updated_at
      )
    end
  end

  describe "scopes" do
    describe ".active" do
      before do
        Reward.create!([
          { name: "A Reward", cost: 100, deactivated_at: nil },
          { name: "B Reward", cost: 100, deactivated_at: nil },
          { name: "C Reward", cost: 100, deactivated_at: Time.now },
        ])
      end

      it "returns a list of active rewards" do
        results = Reward.active

        expect(results.count).to eq 2
        expect(results.first.name).to eq "A Reward"
        expect(results.last.name).to eq "B Reward"
        expect(results.any? { |reward| reward.name == "C Reward" }).to be false
      end
    end
  end

  describe "instance methods" do
    describe "#available?" do
      context "with available inventory" do
        let(:reward) { Reward.new(inventory: 1, deactivated_at: nil) }
        it "is available when not deactivated" do
          result = reward.available?

          expect(result).to be true
        end

        it "is not available when deactivated" do
          reward.deactivated_at = Time.now
          result = reward.available?

          expect(result).to be false
        end
      end

      context "with no inventory" do
        let(:reward) { Reward.new(inventory: 0, deactivated_at: nil) }

        it "is not available when not deactivated" do
          result = reward.available?

          expect(result).to be false
        end

        it "is not available when deactivated" do
          reward.deactivated_at = Time.now
          result = reward.available?

          expect(result).to be false
        end
      end
    end

    describe "#restock" do
      context "when deactivated" do
        let(:reward) { Reward.create!(cost: 50, inventory: 0, name: "Cool Reward", deactivated_at: Time.now) }
        it "activates and sets inventory to 25" do
          result = reward.restock
          restocked_reward = Reward.find(reward.id)

          expect(result).to be true
          expect(restocked_reward.inventory).to eq 25
          expect(restocked_reward.deactivated_at).to be_nil
        end
      end

      context "when activated" do
        let(:reward) { Reward.create!(cost: 10, inventory: 0, name: "Cool Reward", deactivated_at: nil) }
        it "remains active and sets inventory to 25" do
          result = reward.restock
          restocked_reward = Reward.find(reward.id)

          expect(result).to be true
          expect(restocked_reward.inventory).to eq 25
          expect(restocked_reward.deactivated_at).to be_nil
        end
      end
    end
  end
end

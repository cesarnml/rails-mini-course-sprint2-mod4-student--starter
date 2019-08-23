require "rails_helper"

RSpec.describe Employee, type: :model do
  describe "validations" do
    it "is valid" do
      employee = Employee.new(first_name: "Cesar", last_name: "Mejia", rewards_balance: 100)

      result = employee.valid?
      errors = employee.errors.full_messages

      expect(result).to be true
      expect(errors).to be_empty
    end

    it "is invalid without a first_name" do
      employee = Employee.new(first_name: nil, last_name: "Mejia", rewards_balance: 100)

      result = employee.valid?
      errors = employee.errors.full_messages

      expect(result).to be false
      expect(errors).to include("First name can't be blank")
    end

    it "is invalid without a last_name" do
      employee = Employee.new(first_name: "Cesar", last_name: nil, rewards_balance: 100)

      result = employee.valid?
      errors = employee.errors.full_messages

      expect(result).to be false
      expect(errors).to include("Last name can't be blank")
    end
  end

  describe "attributes" do
    it "has expected attributes" do
      employee = Employee.new(first_name: "Cesar", last_name: "Mejia", rewards_balance: 100)

      result = employee.attribute_names.map(&:to_sym)

      expect(result).to contain_exactly(
        :created_at,
        :id,
        :first_name,
        :last_name,
        :rewards_balance,
        :updated_at
      )
    end
  end

  describe "scopes" do
    describe ".zero_balance" do
      before do
        Employee.create!([
          { first_name: "Cesar", last_name: "Mejia", rewards_balance: 0 },
          { first_name: "Luis", last_name: "Martinez", rewards_balance: 0 },
          { first_name: "Ana", last_name: "Mejia", rewards_balance: 100 },
        ])
      end

      it "returns a list of zero reward balance" do
        results = Employee.zero_balance

        expect(results.count).to eq 2
        expect(results.first.first_name).to eq "Cesar"
        expect(results.last.last_name).to eq "Martinez"
        expect(results.any? { |employee| employee.rewards_balance > 0 }).to be false
      end
    end
  end

  describe "instance methods" do
    describe "#full_name" do
      let(:employee) { Employee.create!(first_name: "Cesar", last_name: "Mejia", rewards_balance: 100) }
      it "prints full name" do
        result = employee.full_name

        expect(result).to eq "Cesar Mejia"
      end
    end

    describe "#can_afford?" do
      let(:employee) { Employee.create!(first_name: "Cesar", last_name: "Mejia", rewards_balance: 100) }
      it "can afford when reward balance >= reward cost" do
        result = employee.can_afford?(90)

        expect(result).to be true
      end

      it "can not afford when reward balance < reward cost" do
        result = employee.can_afford?(110)

        expect(result).to be false
      end
    end
  end
end

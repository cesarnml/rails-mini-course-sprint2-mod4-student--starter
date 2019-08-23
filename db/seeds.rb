Employee.create!([
  { first_name: "Jane", last_name: "Doe", rewards_balance: 100 },
  { first_name: "John", last_name: "Doe", rewards_balance: 70 },]
)

Reward.create!([
  { cost: 50,  inventory: 2, deactivated_at: nil, name: "Company T-Shirt", purchase_count: 100 },
  { cost: 150, inventory: 7, deactivated_at: nil, name: "Company Hoodie", purchase_count: 27 },
  { cost: 35, inventory: 11, deactivated_at: nil, name: "Company Mug", purchase_count: 123 },
  { cost: 5, inventory: 0, deactivated_at: Time.now, name: "Company Sticker", purchase_count: 200 }]
)

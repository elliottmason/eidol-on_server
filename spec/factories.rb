# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    email_address { Faker::Internet.email }
    username { Faker::Internet.username }
  end

  factory :account_combatant do
    account
    combatant
    individual_agility { 31 }
    individual_defense { 31 }
    individual_health { 31 }
    individual_power { 31 }
  end

  factory :combatant do
    name { "#{Faker::Creature::Animal.name}-#{Faker::Creature::Animal.name}"}
    base_agility { 100 }
    base_defense { 100 }
    base_health { 100 }
    maximum_energy { 100 }
    initial_remaining_energy { 15 }
    energy_per_turn { 15 }
  end

  factory :match do
  end

  factory :match_combatant do
    trait :knocked_out do
      transient do
        availability { 'knocked_out' }
        remaining_health { 0 }
      end
    end

    transient do
      account { create(:account) }
      availability { 'benched' }
      remaining_health { maximum_health }
    end

    account_combatant { create(:account_combatant, account: account) }
    player { create(:player, account: account) }
    agility { 100 }
    defense { 100 }
    level { 50 }
    maximum_energy { 100 }
    maximum_health { 500 }

    after :create do |match_combatant, options|
      create :match_combatant_status,
             availability: options.availability,
             match_combatant: match_combatant,
             remaining_health: options.remaining_health
    end
  end

  factory :match_combatant_status do
    match_combatant
    remaining_energy { 15 }
    remaining_health { match_combatant.maximum_health }
    availability { 'available' }
  end

  factory :player do
    account
    match
    name { Faker::Name.first_name }
  end
end

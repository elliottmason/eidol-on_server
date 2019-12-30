def create_ampul
  Combatant.find_or_create_by!(
    name: 'Ampul',
    base_agility: 75,
    base_defense: 130,
    base_health: 115,
    energy_per_turn: 20,
    initial_remaining_energy: 15,
    maximum_energy: 100
  )
end

def create_helljung
  Combatant.find_or_create_by!(
    name: 'Helljung',
    base_agility: 110,
    base_defense: 75,
    base_health: 90,
    energy_per_turn: 25,
    initial_remaining_energy: 15,
    maximum_energy: 100
  )
end

def create_mainx
  Combatant.find_or_create_by!(
    name: 'Mainx',
    base_agility: 125,
    base_defense: 65,
    base_health: 90,
    energy_per_turn: 30,
    initial_remaining_energy: 25,
    maximum_energy: 100
  )
end

def create_panser
  Combatant.find_or_create_by!(
    name: 'Panser',
    base_agility: 95,
    base_defense: 95,
    base_health: 95,
    energy_per_turn: 20,
    initial_remaining_energy: 15,
    maximum_energy: 100
  )
end

ActiveRecord::Base.transaction do
  create_ampul
  create_helljung
  create_mainx
  create_panser
end

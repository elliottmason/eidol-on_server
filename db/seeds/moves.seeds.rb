# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
def create_bite
  Move.find_or_create_by!(
    name: 'Bite',
    description: 'Sink your teeth into your foe.',
    range: 1,
    is_diagonal: true,
    energy_cost: 20,
    speed: 1
  ).tap do |move|
    MoveEffect.find_or_create_by!(
      move: move,
      category: 'damage',
      power: 20,
      property: 'cutting'
    )
    MoveEffect.find_or_create_by!(
      move: move,
      category: 'damage',
      power: 20,
      property: 'crushing'
    )
    MoveEffect.find_or_create_by!(
      move: move,
      category: 'status_effect_chance',
      power: 15,
      property: 'poison'
    )
  end
end

def self.create_bolt
  Move.find_or_create_by!(
    name: 'Bolt',
    description: '',
    energy_cost: 25,
    is_diagonal: true,
    range: 2,
    speed: 1
  ).tap do |move|
    MoveEffect.find_or_create_by!(
      category: 'damage',
      move: move,
      power: 25,
      property: 'electric'
    )
  end
end

def self.create_direct_hit
  Move.find_or_create_by!(
    name: 'Direct Hit',
    description: 'Always does exactly 25 damage to targets.',
    energy_cost: 10,
    is_diagonal: true,
    range: 1,
    speed: 1
  ).tap do |move|
    MoveEffect.find_or_create_by!(
      category: 'damage',
      move: move,
      power: 25,
      property: 'direct'
    )
  end
end

def self.create_move
  Move.find_or_create_by!(
    name: 'Move',
    description: 'Relocate to an adjacent position.',
    energy_cost: 10,
    is_diagonal: true,
    range: 1,
    speed: 1
  ).tap do |move|
    MoveEffect.find_or_create_by!(
      category: 'relocation',
      move: move,
      power: 0,
      property: 'normal'
    )
  end
end

def self.create_scratch
  Move.find_or_create_by!(
    name: 'Scratch',
    description: 'Swipe a target with your sharp claws, which may cause them to bleed',
    energy_cost: 15,
    is_diagonal: false,
    range: 1,
    speed: 2
  ).tap do |move|
    MoveEffect.find_or_create_by!(
      category: 'damage',
      move: move,
      power: 25,
      property: 'cutting'
    )
  end
end

def self.create_water_hose
  Move.find_or_create_by!(
    name: 'Water hose',
    description: 'Blast an opponent with a torrent of water. You might stun them.',
    energy_cost: 25,
    is_diagonal: true,
    range: 2,
    speed: 1
  ).tap do |move|
    MoveEffect.find_or_create_by!(
      category: 'damage',
      move: move,
      power: 25,
      property: 'water'
    )
  end
end
# rubocop:enable Metrics/MethodLength

ActiveRecord::Base.transaction do
  create_bite
  create_bolt
  create_direct_hit
  create_move
  create_scratch
  create_water_hose
end

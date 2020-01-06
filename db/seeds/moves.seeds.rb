# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
def create_bite_move
  Move.find_or_create_by!(
    name: 'Bite',
    description: 'Sink your teeth into your foe',
    range: 1,
    is_diagonal: true,
    energy_cost: 20
  ).tap do |move|
    MoveTurn.find_or_create_by!(
      move: move,
      turn: 1,
      speed: 1
    ).tap do |move_turn|
      MoveTurnEffect.find_or_create_by!(
        move_turn: move_turn,
        category: 'damage',
        power: 20,
        property: 'cutting'
      )
      MoveTurnEffect.find_or_create_by!(
        move_turn: move_turn,
        category: 'damage',
        power: 20,
        property: 'crushing'
      )
      MoveTurnEffect.find_or_create_by!(
        move_turn: move_turn,
        category: 'status_effect_chance',
        power: 15,
        property: 'poison'
      )
    end
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
    MoveTurn.find_or_create_by!(
      move: move,
      turn: 1,
      speed: 1
    ).tap do |move_turn|
      MoveTurnEffect.find_or_create_by!(
        category: 'damage',
        move_turn: move_turn,
        power: 25,
        property: 'electric'
      )
    end
  end
end

def self.create_direct_hit
  Move.find_or_create_by!(
    name: 'Direct Hit',
    description: 'always does exactly 25 damage to targets',
    energy_cost: 10,
    is_diagonal: true,
    range: 1,
    speed: 1
  ).tap do |move|
    MoveTurn.find_or_create_by!(
      move: move,
      turn: 1,
      speed: 1,
    ).tap do |move_turn|
      MoveTurnEffect.find_or_create_by!(
        category: 'damage',
        move_turn: move_turn,
        power: 25,
        property: 'direct'
      )
    end
  end
end

def self.create_move
  Move.find_or_create_by!(
    name: 'Move',
    description: 'to another position on the board',
    energy_cost: 10,
    is_diagonal: true,
    range: 1,
    speed: 1
  ).tap do |move|
    MoveTurn.find_or_create_by!(
      move: move,
      turn: 1,
      speed: 1,
    ).tap do |move_turn|
      MoveTurnEffect.find_or_create_by!(
        category: 'relocation',
        move_turn: move_turn,
        power: 0,
        property: 'normal'
      )
    end
  end
end

def self.create_scratch
  Move.find_or_create_by!(
    name: 'Scratch',
    description: 'an oponent with sharp claws, which may cause them to bleed',
    energy_cost: 15,
    is_diagonal: false,
    range: 1,
    speed: 2
  ).tap do |move|
    MoveTurn.find_or_create_by!(
      move: move,
      turn: 1,
      speed: 2
    ).tap do |move_turn|
      MoveTurnEffect.find_or_create_by!(
        category: 'damage',
        move_turn: move_turn,
        power: 25,
        property: 'cutting'
      )
    end
  end
end

def self.create_water_hose
  Move.find_or_create_by!(
    name: 'Water hose',
    description: 'blast an opponent with water, possibly stunning them',
    energy_cost: 25,
    is_diagonal: true,
    range: 2,
    speed: 1
  ).tap do |move|
    MoveTurn.find_or_create_by!(
      move: move,
      turn: 1,
      speed: 1
    ).tap do |move_turn|
      MoveTurnEffect.find_or_create_by!(
        category: 'damage',
        move_turn: move_turn,
        power: 25,
        property: 'water'
      )
    end
  end
end
# rubocop:enable Metrics/MethodLength

ActiveRecord::Base.transaction do
  create_move
  create_direct_hit
end

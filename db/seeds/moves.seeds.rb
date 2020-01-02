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

ActiveRecord::Base.transaction do
  create_move
  create_direct_hit
end

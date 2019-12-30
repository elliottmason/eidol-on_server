def create_move
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
        # order: 1,
        power: 0,
        property: 'normal'
      )
    end
  end
end

ActiveRecord::Base.transaction do
  create_move
end

# frozen_string_literal: true

# @return [Array<String>]
COMBATANT_NAMES = %w[Ampul Helljung Mainx Panser].freeze

# @return [Array<String>]
PLAYER_NAMES = %w[Branden Elliott].freeze

# @return [Array<String>]
def combatant_names
  Array(COMBATANT_NAMES)
end

# @return [Array<String>]
def player_names
  Array(PLAYER_NAMES)
end

combatants = {}

combatant_names.each do |name|
  name_hash_key = name.downcase.to_sym
  combatants[name_hash_key] = Combatant.create!(name: name)
end

# @return [Hash{Symbol => Player}]
def players
  return @players if @players

  @players = {}
  player_names.each do |name|
    @players[name.downcase.to_sym] = Player.create!(name: name)
  end

  @players
end

player_combatants = {
  branden: {
    ampul: PlayerCombatant.create!(
      combatant: combatants[:ampul],
      player: players[:branden]
    ),
    panser: PlayerCombatant.create!(
      combatant: combatants[:panser],
      player: players[:branden]
    )
  },
  elliott: {
    helljung: PlayerCombatant.create!(
      combatant: combatants[:helljung],
      player: players[:elliott]
    ),
    mainx: PlayerCombatant.create!(
      combatant: combatants[:mainx],
      player: players[:elliott]
    )
  }
}

# @param speed [Integer]
# @return [Move]
def create_move_move(speed:)
  ActiveRecord::Base.transaction do
    move =
      Move.create!(
        name: 'Move',
        description: 'to another position on the board',
        range: 1,
        is_diagonal: true,
        energy_cost: 1
      )

    move_turn =
      MoveTurn.new(
        move: move,
        turn: 1,
        speed: speed
      )

    MoveTurnEffect.create(
      category: 'relocation',
      move_turn: move_turn,
      power: 0,
      property: 'normal'
    )
    move
  end
end

# @param speed [Integer]
# @return [Move]
def create_bolt_move(speed: 70)
  ActiveRecord::Base.transaction do
    # @type [Move]
    move =
      Move.create!(
        name: 'Bolt',
        description: 'Summon a lightning bolt from above',
        range: 1,
        is_diagonal: true,
        energy_cost: 3
      )

    move_turn =
      MoveTurn.new(
        move: move,
        turn: 1,
        speed: speed
      )

    MoveTurnEffect.create!(
      category: 'damage',
      move_turn: move_turn,
      power: 50,
      property: 'electric'
    )

    break move
  end
end

# @param speed [Integer]
# @return [Move]
def create_bite_move(speed: 75)
  ActiveRecord::Base.transaction do
    move =
      Move.create!(
        name: 'Bite',
        description: 'Sink your teeth into your foe',
        range: 1,
        is_diagonal: true,
        energy_cost: 2
      )

    move_turn =
      MoveTurn.create!(
        move: move,
        turn: 1,
        speed: speed
      )

    MoveTurnEffect.create!(
      move_turn: move_turn,
      category: 'damage',
      power: 25,
      property: 'cutting'
    )

    MoveTurnEffect.create!(
      move_turn: move_turn,
      category: 'damage',
      power: 25,
      property: 'crushing'
    )

    MoveTurnEffect.create!(
      move_turn: move_turn,
      category: 'status_effect_chance',
      power: 25,
      property: 'poison'
    )

    move
  end
end

ampul_moves = { move: create_move_move(speed: 35) }
helljung_moves = { move: create_move_move(speed: 75), bolt: create_bolt_move }
mainx_moves = { move: create_move_move(speed: 120) }
panser_moves = { move: create_move_move(speed: 60), bite: create_bite_move }

player_combatants[:branden][:ampul].moves = ampul_moves.values
player_combatants[:branden][:panser].moves = panser_moves.values
player_combatants[:elliott][:helljung].moves = helljung_moves.values
player_combatants[:elliott][:mainx].moves = mainx_moves.values

# @type [Matches::Create]
match_creator = Matches::Create.for(players: players.values)
# @type [Match]
match = match_creator.match
# @type [Board]
board = match.board

MatchCombatants::Deploy.with(
  board_position: BoardPosition.where(board: board, x: 1, y: 1).first,
  match_combatant: match.match_combatants.first
)

MatchCombatants::Deploy.with(
  board_position: BoardPosition.where(board: board, x: 1, y: 2).first,
  match_combatant: match.match_combatants.offset(1).first
)

MatchCombatants::Deploy.with(
  board_position: BoardPosition.where(board: board, x: 2, y: 2).first,
  match_combatant: match.match_combatants.offset(2).first
)

MatchCombatants::Deploy.with(
  board_position: BoardPosition.where(board: board, x: 2, y: 3).first,
  match_combatant: match.match_combatants.offset(3).first
)

Matches::AdvanceTurn.for(match: match).match_turn

(0..3).each do |offset|
  MatchCombatantsMoves::Select.with(
    board_position:
      BoardPosition.where(board: board, x: rand(0..3), y: rand(0..3)).first,
    match_combatants_move: MatchCombatantsMove.offset(offset).first,
    match_turn: match.turn,
    source_board_position: MatchCombatant.offset(offset).first.position
  )
end

MatchTurns::Process.for(match_turn: match.turn)

(0..3).each do |offset|
  MatchCombatantsMoves::Select.with(
    board_position:
      BoardPosition.where(board: board, x: rand(0..3), y: rand(0..3)).first,
    match_combatants_move: MatchCombatantsMove.offset(offset).first,
    match_turn: match.turn,
    source_board_position: MatchCombatant.offset(offset).first.position
  )
end

MatchTurns::Process.for(match_turn: match.turn)

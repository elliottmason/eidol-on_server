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
    effect_type: 'relocation_normal',
    move_turn: move_turn,
    power: 0,
    precedence: 0
  )
  move
end

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
      effect_type: 'damage_electric',
      move_turn: move_turn,
      power: 50,
      precedence: 0
    )

    MoveTurnEffect.create!(
      effect_type: 'status_effect_chance_paralysis',
      move_turn: move_turn,
      power: 15,
      precedence: 0
    )

    break move
  end
end

ampul_move_move = create_move_move(speed: 35)
helljung_move_move = create_move_move(speed: 75)
mainx_move_move = create_move_move(speed: 120)
panser_move_move = create_move_move(speed: 60)

helljung_bolt = create_bolt_move(speed: 70)

helljung_moves = [helljung_move_move] #, helljung_bolt]

player_combatants[:branden][:ampul].moves << ampul_move_move
player_combatants[:branden][:panser].moves << panser_move_move
player_combatants[:elliott][:helljung].moves.concat(helljung_moves)
player_combatants[:elliott][:mainx].moves << mainx_move_move

# @type [Matches::Create]
match_creator = Matches::Create.for(players: players.values)
# @type [Match]
match = match_creator.match
# @type [Board]
board = match.board
# @type [MatchTurn]
match_turn = match.current_turn

BoardPositionsMatchCombatant.create!(
  board_position: BoardPosition.where(board: board, x: 1, y: 1).first,
  match_combatant: match.match_combatants.first
)

BoardPositionsMatchCombatant.create!(
  board_position: BoardPosition.where(board: board, x: 1, y: 2).first,
  match_combatant: match.match_combatants.offset(1).first
)

BoardPositionsMatchCombatant.create!(
  board_position: BoardPosition.where(board: board, x: 2, y: 2).first,
  match_combatant: match.match_combatants.offset(2).first
)

BoardPositionsMatchCombatant.create!(
  board_position: BoardPosition.where(board: board, x: 2, y: 3).first,
  match_combatant: match.match_combatants.offset(3).first
)

Matches::AdvanceTurn.for(match: match)

match_turn = match.current_turn

(0..3).each do |offset|
  MatchCombatantsMoves::Select.with(
    board_position:
      BoardPosition.where(board: board, x: rand(4), y: rand(4)).first,
    match_combatants_move:
      MatchCombatantsMove.offset(offset).first,
    match_turn: match_turn,
    source_board_position:
      MatchCombatant.offset(offset).first.current_position
  )
end

MatchTurns::Process.for(match_turn: match_turn)

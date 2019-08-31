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

combatants_players = {
  branden: {
    ampul: CombatantsPlayer.create!(
      combatant: combatants[:ampul],
      player: players[:branden]
    ),
    panser: CombatantsPlayer.create!(
      combatant: combatants[:panser],
      player: players[:branden]
    )
  },
  elliott: {
    helljung: CombatantsPlayer.create!(
      combatant: combatants[:helljung],
      player: players[:elliott]
    ),
    mainx: CombatantsPlayer.create!(
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
  end

  move
end

ampul_move_move = create_move_move(speed: 35)
helljung_move_move = create_move_move(speed: 75)
mainx_move_move = create_move_move(speed: 120)
panser_move_move = create_move_move(speed: 60)

helljung_bolt = create_bolt_move

helljung_moves = [helljung_move_move, helljung_bolt]

combatants_players[:branden][:ampul].moves << ampul_move_move
combatants_players[:branden][:panser].moves << panser_move_move
combatants_players[:elliott][:helljung].moves.concat(helljung_moves)
combatants_players[:elliott][:mainx].moves << mainx_move_move

# @type [Matches::Create]
match_creator = Matches::Create.for(players: players.values)
# @type [Match]
match = match_creator.match
# @type [Board]
board = match.board
# @type [MatchTurn]
match_turn = match.current_turn

BoardPositionsCombatantsPlayersMatch.create!(
  board_position: BoardPosition.where(board: board, x: 1, y: 1).first,
  combatants_players_match: match.combatants_players_matches.first,
  match_turn: match_turn
)

BoardPositionsCombatantsPlayersMatch.create!(
  board_position: BoardPosition.where(board: board, x: 1, y: 2).first,
  combatants_players_match: match.combatants_players_matches.offset(1).first,
  match_turn: match_turn
)

BoardPositionsCombatantsPlayersMatch.create!(
  board_position: BoardPosition.where(board: board, x: 2, y: 2).first,
  combatants_players_match: match.combatants_players_matches.offset(2).first,
  match_turn: match_turn
)

BoardPositionsCombatantsPlayersMatch.create!(
  board_position: BoardPosition.where(board: board, x: 2, y: 3).first,
  combatants_players_match: match.combatants_players_matches.offset(3).first,
  match_turn: match_turn
)

Matches::AdvanceTurn.for(match: match)

match_turn = match_creator.match.current

(0..3).each do |offset|
  CombatantsPlayersMatchesMoves::Select.with(
    board_position:
      BoardPosition.where(board: board, x: rand(4), y: rand(4)).first,
    combatants_players_matches_move:
      CombatantsPlayersMatchesMove.offset(offset).first,
    match_turn: match_turn
  )
end

MatchTurns::Process.for(match_turn: match_turn)

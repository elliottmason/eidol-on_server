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

ampul_move = create_move_move(speed: 35)
helljung_move = create_move_move(speed: 75)
mainx_move = create_move_move(speed: 120)
panser_move = create_move_move(speed: 60)

combatants_players[:branden][:ampul].moves << ampul_move
combatants_players[:branden][:panser].moves << panser_move
combatants_players[:elliott][:helljung].moves << helljung_move
combatants_players[:elliott][:mainx].moves << mainx_move

# @return [Matches::Create]
def match_creator
  Matches::Create.for(players: players.values)
end

board = match_creator.match.board
first_match_turn = match_creator.match.turns.first

(0..3).each do |offset|
  CombatantsPlayersMatchesMoves::Select.with(
    board_position:
      BoardPosition.where(board: board, x: rand(4), y: rand(4)).first,
    combatants_players_matches_move:
      CombatantsPlayersMatchesMove.offset(offset).first,
    match_turn:
      first_match_turn
  )
end

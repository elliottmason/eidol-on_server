COMBATANT_NAMES = ['Ampul', 'Helljung', 'Mainx', 'Panser']
PLAYER_NAMES = ['Branden', 'Elliott']

combatants = {}
COMBATANT_NAMES.each do |name|
  name_hash_key = name.downcase.to_sym
  combatants[name_hash_key] = Combatant.create(name: name)
end

players = {}
PLAYER_NAMES.each do |name|
  name_hash_key = name.downcase.to_sym
  players[name_hash_key] = Player.create(name: name)
end

combatants_players = {
  branden: {
    ampul: CombatantsPlayer.create(
      combatant: combatants[:ampul],
      player: players[:branden]
    ),
    panser: CombatantsPlayer.create(
      combatant: combatants[:panser],
      player: players[:branden]
    )
  },
  elliott: {
    helljung: CombatantsPlayer.create(
      combatant: combatants[:helljung],
      player: players[:elliott]
    ),
    mainx: CombatantsPlayer.create(
      combatant: combatants[:mainx],
      player: players[:elliott]
    )
  }
}

def create_move_move(speed:)
  move =
    Move.create(
      name: 'Move',
      description: 'to another position on the board',
      range: 1,
      is_diagonal: true,
      energy_cost: 1
    )

  turn =
    MoveTurn.new(
      turn: 1,
      speed: speed
    )

  move.turns << turn

  turn_effect =
    MoveTurnEffect.new(
      effect_type: 'relocation',
      property: 'normal',
      power: 0,
      precedence: 1
    )

  turn.effects << turn_effect

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

match_creator = Matches::Create.for(players: players.values)

board = match_creator.match.board
first_match_turn = match_creator.match.turns.first

CombatantsPlayersMatchesMovesMatchTurn.create!(
  board_position:
    BoardPosition.where(board: board, x: rand(4), y: rand(4)).first,
  combatants_players_matches_move: CombatantsPlayersMatchesMove.first,
  match_turn: first_match_turn
)

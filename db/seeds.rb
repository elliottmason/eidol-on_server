# frozen_string_literal: true

# @return [Array<String>]
COMBATANT_NAMES = %w[Ampul Helljung Mainx Panser].freeze

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

    MoveTurnEffect.create!(
      category: 'relocation',
      move_turn: move_turn,
      power: 0,
      property: 'normal'
    )

    move
  end
end

def create_bolt_move(speed: 70)
  ActiveRecord::Base.transaction do
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

ActiveRecord::Base.establish_connection
ActiveRecord::Base.connection.tables.each do |table|
  next if table == 'schema_migrations'

  ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
end

accounts = {
  branden: Account.create!(
    email_address: 'bwieg@gmail.org',
    username: 'BeWiegland420'
  ),
  elliott: Account.create!(
    email_address: 'eleo@fastmail.fm',
    username: 'Eleo'
  )
}

combatants = {}

COMBATANT_NAMES.each do |name|
  name_hash_key = name.downcase.to_sym
  combatants[name_hash_key] = Combatant.create!(name: name)
end

account_combatants = {
  branden: {
    ampul: AccountCombatant.create!(
      account: accounts[:branden],
      combatant: combatants[:ampul]
    ),
    panser: AccountCombatant.create!(
      account: accounts[:branden],
      combatant: combatants[:panser]
    )
  },

  elliott: {
    helljung: AccountCombatant.create!(
      account: accounts[:elliott],
      combatant: combatants[:helljung]
    ),
    mainx: AccountCombatant.create!(
      account: accounts[:elliott],
      combatant: combatants[:mainx]
    )
  }
}

ampul_moves = { move: create_move_move(speed: 35) }
helljung_moves = { move: create_move_move(speed: 75), bolt: create_bolt_move }
mainx_moves = { move: create_move_move(speed: 120) }
panser_moves = { move: create_move_move(speed: 60), bite: create_bite_move }

account_combatants[:branden][:ampul].moves = ampul_moves.values
account_combatants[:branden][:panser].moves = panser_moves.values
account_combatants[:elliott][:helljung].moves = helljung_moves.values
account_combatants[:elliott][:mainx].moves = mainx_moves.values

# @type [Matches::Create]
Matches::Create.for(accounts: accounts.values)

# # @type [Match]
# match = match_creator.match

# MatchCombatants::Deploy.with(
#   board_position: BoardPosition.where(match: match, x: 1, y: 1).first,
#   match_combatant: match.match_combatants.first
# )

# MatchCombatants::Deploy.with(
#   board_position: BoardPosition.where(match: match, x: 1, y: 2).first,
#   match_combatant: match.match_combatants.offset(1).first
# )

# MatchCombatants::Deploy.with(
#   board_position: BoardPosition.where(match: match, x: 2, y: 2).first,
#   match_combatant: match.match_combatants.offset(2).first
# )

# MatchCombatants::Deploy.with(
#   board_position: BoardPosition.where(match: match, x: 2, y: 3).first,
#   match_combatant: match.match_combatants.offset(3).first
# )

# Matches::AdvanceTurn.for(match: match).match_turn

# (0..3).each do |offset|
#   MatchMoveSelections::Create.with(
#     board_position:
#       BoardPosition.where(match: match, x: rand(0..3), y: rand(0..3)).first,
#     match_combatants_move: MatchCombatantsMove.offset(offset).first,
#     match_turn: match.turn
#   )
# end

# MatchMoveTurns::QueueFromMoveSelections.for(match_turn: match.turn)
# MatchTurns::Process.for(match_turn: match.turn)

# (0..3).each do |offset|
#   MatchMoveSelections::Create.with(
#     board_position:
#       BoardPosition.where(match: match, x: rand(0..3), y: rand(0..3)).first,
#     match_combatants_move: MatchCombatantsMove.offset(offset).first,
#     match_turn: match.turn
#   )
# end

# MatchMoveTurns::QueueFromMoveSelections.for(match_turn: match.turn)
# MatchTurns::Process.for(match_turn: match.turn)

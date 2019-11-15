# frozen_string_literal: true

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

def create_solarbeam_move
  ActiveRecord::Base.transaction do
    move =
      Move.create!(
        name: 'Solarbeam',
        description: 'I stole this from Pokémon',
        range: 4,
        is_diagonal: false,
        energy_cost: 2
      )

    move_turn_1 =
      MoveTurn.create!(
        move: move,
        turn: 1,
        speed: 50
      )

    MoveTurnEffect.create!(
      move_turn: move_turn_1,
      category: 'charge',
      power: 25,
      property: 'normal'
    )

    move_turn_2 =
      MoveTurn.create!(
        move: move,
        turn: 2,
        speed: 100
      )

    MoveTurnEffect.create!(
      move_turn: move_turn_2,
      category: 'damage',
      power: 90,
      property: 'cutting'
    )

    move
  end
end

ActiveRecord::Base.establish_connection
# @param table [String]
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

combatants[:ampul] =
  Combatant.create!(
    name: 'Ampul',
    base_defense: 255,
    base_health: 255
  )

combatants[:helljung] =
  Combatant.create!(
    name: 'Helljung',
    base_defense: 70,
    base_health: 70
  )

combatants[:mainx] =
  Combatant.create!(
    name: 'Mainx',
    base_defense: 65,
    base_health: 75
  )

combatants[:panser] =
  Combatant.create!(
    name: 'Panser',
    base_defense: 80,
    base_health: 95
  )


account_combatants = {
  branden: {
    ampul: AccountCombatants::Create.with(
      account: accounts[:branden],
      combatant: combatants[:ampul]
    ).account_combatant,
    panser: AccountCombatants::Create.with(
      account: accounts[:branden],
      combatant: combatants[:panser]
    ).account_combatant
  },

  elliott: {
    helljung: AccountCombatants::Create.with(
      account: accounts[:elliott],
      combatant: combatants[:helljung]
    ).account_combatant,
    mainx: AccountCombatants::Create.with(
      account: accounts[:elliott],
      combatant: combatants[:mainx]
    ).account_combatant
  }
}

account_combatants[:branden][:ampul].moves = [
  create_move_move(speed: 35),
  create_solarbeam_move
]

account_combatants[:branden][:panser].moves = [
  create_move_move(speed: 75),
  create_bite_move
]

account_combatants[:elliott][:helljung].moves = [
  create_move_move(speed: 120),
  create_bolt_move
]

account_combatants[:elliott][:mainx].moves = [
  create_move_move(speed: 60)
]

# @type [Matches::Create]
Matches::Create.for(accounts: accounts.values)

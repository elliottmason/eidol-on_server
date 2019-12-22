# frozen_string_literal: true

def create_move_move(speed:)
  ActiveRecord::Base.transaction do
    move =
      Move.create!(
        name: 'Move',
        description: 'to another position on the board',
        range: 1,
        is_diagonal: true,
        energy_cost: 10
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
        energy_cost: 25
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
        energy_cost: 20
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
      power: 20,
      property: 'cutting'
    )

    MoveTurnEffect.create!(
      move_turn: move_turn,
      category: 'damage',
      power: 20,
      property: 'crushing'
    )

    MoveTurnEffect.create!(
      move_turn: move_turn,
      category: 'status_effect_chance',
      power: 15,
      property: 'poison'
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
    base_agility: 75,
    base_defense: 130,
    base_health: 115,
    energy_per_turn: 20,
    initial_remaining_energy: 20,
    maximum_energy: 100
  )

combatants[:helljung] =
  Combatant.create!(
    name: 'Helljung',
    base_agility: 110,
    base_defense: 75,
    base_health: 90,
    energy_per_turn: 20,
    initial_remaining_energy: 16,
    maximum_energy: 100
  )

combatants[:mainx] =
  Combatant.create!(
    name: 'Mainx',
    base_agility: 125,
    base_defense: 65,
    base_health: 90,
    energy_per_turn: 25,
    initial_remaining_energy: 25,
    maximum_energy: 100
  )

combatants[:panser] =
  Combatant.create!(
    name: 'Panser',
    base_agility: 95,
    base_defense: 95,
    base_health: 95,
    energy_per_turn: 25,
    initial_remaining_energy: 15,
    maximum_energy: 100
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
  create_move_move(speed: 35)
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
  create_move_move(speed: 60),
  create_bite_move
]

# @type [Matches::Create]
Matches::Create.for(accounts: accounts.values)

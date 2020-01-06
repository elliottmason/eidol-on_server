# frozen_string_literal: true

accounts = {
  branden: Account.find_or_create_by!(
    email_address: 'bwieg@gmail.org',
    username: 'BeWiegland420'
  ),
  elliott: Account.find_or_create_by!(
    email_address: 'eleo@fastmail.fm',
    username: 'Eleo'
  )
}

account_combatants = {
  branden: {
    ampul: AccountCombatants::Create.with(
      account: accounts[:branden],
      combatant: Combatant.find_by(name: 'Ampul')
    ).account_combatant,
    panser: AccountCombatants::Create.with(
      account: accounts[:branden],
      combatant: Combatant.find_by(name: 'Panser')
    ).account_combatant
  },

  elliott: {
    helljung: AccountCombatants::Create.with(
      account: accounts[:elliott],
      combatant: Combatant.find_by(name: 'Helljung')
    ).account_combatant,
    mainx: AccountCombatants::Create.with(
      account: accounts[:elliott],
      combatant: Combatant.find_by(name: 'Mainx')
    ).account_combatant
  }
}

account_combatants[:branden][:ampul].moves = [
  Move.find_by(name: 'Move'),
  Move.find_by(name: 'Water hose')
]

account_combatants[:branden][:panser].moves = [
  Move.find_by(name: 'Move'),
  Move.find_by(name: 'Bite')
]

account_combatants[:elliott][:helljung].moves = [
  Move.find_by(name: 'Move'),
  Move.find_by(name: 'Bolt')
]

account_combatants[:elliott][:mainx].moves = [
  Move.find_by(name: 'Move'),
  Move.find_by(name: 'Scratch')
]

Matches::Create.for(accounts: accounts.values)

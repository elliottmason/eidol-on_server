require 'rails_helper'

describe 'Knocked out combatants' do
  let(:accounts) { FactoryBot.create_list(:account, 2, :with_combatants) }
  let(:match) { Matches::Create.for(accounts: accounts).match }
  let(:player_a) { match.players.first }
  let(:player_b) { match.players.last }
  let(:source_combatant) { player_a.combatants.first }
  let(:target_combatant) { player_b.combatants.first }

  let(:move) { Move.find_by_name('Direct Hit') }
  let(:source_match_combatants_move) do
    MatchCombatantsMove.where(
      match_combatant: source_combatant,
      move: move
    ).first
  end
  let(:target_match_combatants_move) do {
    MatchCombatantsMove.where(
      match_combatant: target_combatant,
      move: move
    ).first
  }

  let(:source_position) { match.board_positions.where(x: 2, y: 1).first}
  let(:target_position) { match.board_positions.where(x: 2, y: 2). first }

  before do
    MatchCombatants::Deploy.with(
      board_position: source_position,
      match_combatant: source_combatant
    )

    MatchCombatants::Deploy.with(
      board_position: target_position,
      match_combatant: target_combatant
    )
    # which should cause the turn to advance automatically?

    MatchMoveSelections::Create.with(
      board_position: target_position,
      match_combatants_move: source_match_combatants_move
    )

    MatchMoveSelections::Create.with(
      board_position: source_position,
      match_combatants_move: target_match_combatants_move
    )
    # which should cause the turn to be processed automatically?
    # at which point their respective attacks should run
    # and target_combatant should be KO'd
  end

  it 'moves are not processed or applied' do
    puts target_combatant.remaining_health
    puts target_combatant.maximum_health
    puts '---'
    expect(target_combatant).to be_knocked_out
    expect(source_combatant.remaining_health).to eq source_combatant.maximum_health
  end
end

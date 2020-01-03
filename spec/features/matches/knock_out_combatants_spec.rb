# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Knocked out combatants' do
  let(:accounts) { FactoryBot.create_list(:account, 2, :with_combatants) }
  let!(:match) { Matches::Create.for(accounts: accounts).match }
  let(:player_a) { match.players.first }
  let(:player_b) { match.players.last }
  let!(:source_combatant) { player_a.combatants.first }
  let!(:target_combatant) { player_b.combatants.first }

  let(:move) { Move.find_by(name: 'Direct Hit') }
  let(:source_match_combatants_move) do
    MatchCombatantsMove.where(
      match_combatant: source_combatant,
      move: move
    ).first
  end
  let(:target_match_combatants_move) do
    MatchCombatantsMove.where(
      match_combatant: target_combatant,
      move: move
    ).first
  end

  let(:source_position) { match.board_positions.where(x: 2, y: 1).first }
  let(:target_position) { match.board_positions.where(x: 2, y: 2).first }

  before do
    # Lower remaining_health down to 1
    [source_combatant, target_combatant].each do |combatant|
      amount = 1 - combatant.maximum_health
      MatchCombatants::AdjustRemainingHealth.with(
        amount: amount, match_combatant: combatant
      )
    end

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
  end

  it 'moves are not processed or applied' do
    expect(target_combatant).to be_knocked_out
    expect(source_combatant.remaining_health).to eq(1)
  end
end
# rubocop:enable Metrics/BlockLength

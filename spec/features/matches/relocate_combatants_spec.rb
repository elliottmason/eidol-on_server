# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Relocating combatants' do
  let!(:account_a) { FactoryBot.create(:account, combatants: %i[helljung]) }
  let!(:account_b) { FactoryBot.create(:account, combatants: %i[ampul]) }
  let!(:match) { Matches::Create.for(accounts: [account_a, account_b]).match }
  let(:player_a) { match.players.first }
  let(:player_b) { match.players.last }
  let!(:combatant_a) { player_a.combatants.first }
  let!(:combatant_b) { player_b.combatants.first }
  let(:move) { Move.find_by(name: 'Move') }
  let(:combatant_a_move) do
    MatchCombatantsMove.find_by(match_combatant: combatant_a, move: move)
  end
  let(:combatant_b_move) do
    MatchCombatantsMove.find_by(match_combatant: combatant_b, move: move)
  end

  let(:initial_position_a) { match.board_positions.find_by(x: 2, y: 1) }
  let(:initial_position_b) { match.board_positions.find_by(x: 2, y: 2) }
  let(:target_position_a) { match.board_positions.find_by(x: 1, y: 2) }
  let(:target_position_b) { match.board_positions.find_by(x: 1, y: 1) }

  before do
    # Lower remaining_health of both combatantsb down to 1
    [combatant_a, combatant_b].each do |combatant|
      amount = 1 - combatant.maximum_health
      MatchCombatants::AdjustRemainingHealth.with(
        amount: amount, match_combatant: combatant
      )
    end

    MatchCombatants::Deploy.with(
      board_position: initial_position_a,
      match_combatant: combatant_a
    )

    MatchCombatants::Deploy.with(
      board_position: initial_position_b,
      match_combatant: combatant_b
    )
    # which should cause the turn to advance automatically?
    # this doesn't seem to affect the test either way, which is concerning
  end

  context 'to valid positions' do
    before do
      MatchMoveSelections::Create.with(
        board_position: target_position_a,
        match_combatants_move: combatant_a_move
      )

      MatchMoveSelections::Create.with(
        board_position: target_position_b,
        match_combatants_move: combatant_b_move
      )
    end

    it 'places combatants at new positions' do
      expect(combatant_a.position).to eq target_position_a
      expect(combatant_b.position).to eq target_position_b
    end
  end

  context 'to occupied positions' do
    before do
      MatchMoveSelections::Create.with(
        board_position: initial_position_b,
        match_combatants_move: combatant_a_move
      )

      MatchMoveSelections::Create.with(
        board_position: initial_position_a,
        match_combatants_move: combatant_b_move
      )
    end

    it "does not change combatant's positions" do
      expect(combatant_a.position).to eq initial_position_a
      expect(combatant_b.position).to eq initial_position_b
    end
  end

  context 'to the same position' do
    before do
      MatchMoveSelections::Create.with(
        board_position: target_position_a,
        match_combatants_move: combatant_a_move
      )

      MatchMoveSelections::Create.with(
        board_position: target_position_a,
        match_combatants_move: combatant_b_move
      )
    end

    it "places only the faster combatant to the target position" do
    end
  end
end
# rubocop:enable Metrics/BlockLength

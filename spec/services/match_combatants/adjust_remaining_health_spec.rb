# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe MatchCombatants::AdjustRemainingHealth do
  let!(:match_combatant) { FactoryBot.create(:match_combatant) }

  context 'combatant is knocked out' do
    let!(:match_combatant) do
      FactoryBot.create(:match_combatant, :knocked_out)
    end

    it 'does not allow health to be added' do
      described_class.with(
        amount: 10,
        match_combatant: match_combatant
      )
      match_combatant.reload
      expect(match_combatant.remaining_health).to eql 0
    end

    it 'does not allow health to be reduced' do
      described_class.with(
        amount: 10,
        match_combatant: match_combatant
      )
      match_combatant.reload
      expect(match_combatant.remaining_health).to eql 0
    end
  end

  it 'does not allow remaining health to fall below 0' do
    described_class.with(amount: -10_000, match_combatant: match_combatant)
    match_combatant.reload
    expect(match_combatant.remaining_health).to eql 0
  end

  it 'does not allow remaining health to exceed maximum health' do
    described_class.with(amount: 10_000, match_combatant: match_combatant)
    match_combatant.reload
    expect(match_combatant.remaining_health).to \
      eql match_combatant.maximum_health
  end

  it 'knocks the combatant out if its health reaches 0' do
    described_class.with(amount: -10_000, match_combatant: match_combatant)
    match_combatant.reload
    expect(match_combatant.knocked_out?).to be true
  end
end
# rubocop:enable Metrics/BlockLength

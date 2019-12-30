# frozen_string_literal: true

RSpec.describe MatchCombatants::KnockOut do
  let!(:account) { FactoryBot.create(:account) }
  let!(:account_combatant) do
    AccountCombatants::Create.with(
      account: account,
      combatant: Combatant.order('RANDOM()').first,
    ).account_combatant
  end
  let!(:player) { FactoryBot.create(:player, account: account) }
  let!(:match_combatant) do
    MatchCombatants::Create.with(
      account_combatant: account_combatant,
      player: player,
    ).match_combatant
  end

  it "cancels the combatant's queued move turns" do
    def unprocessed_match_move_turns
      MatchMoveTurn.unprocessed.where(match_combatant: match_combatant)
    end

    # first we need to queue up some move turns

    expect(unprocessed_match_move_turns).to_not be_empty
    described_class.for(match_combatant)
    expect(unprocessed_match_move_turns).to be_empty
  end
end

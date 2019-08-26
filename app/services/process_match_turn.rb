class ProcessMatchTurn < ApplicationService
  # collect unprocessed move selections for this turn
  # order move selections by precedence
  # process the first move selection in the list
  #   determine the effects of the selected move
  #   store the effects of the move
  #   apply the effects of the move
  #   mark the move selection as processed
  # loop
  # advance match turn by 1

  def perform
  end

  def unprocessed_move_selections
  end
end

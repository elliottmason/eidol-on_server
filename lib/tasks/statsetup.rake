# frozen_string_literal: true

task stats: 'statsetup'

task :statsetup do
  require 'rails/code_statistics'

  STATS_DIRECTORIES = [
    %w[Channels app/channels],
    %w[Controllers app/controllers],
    %w[Models app/models],
    %w[Services app/services]
  ]

  # CodeStatistics::TEST_TYPES
end

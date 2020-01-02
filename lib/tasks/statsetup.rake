# frozen_string_literal: true

task stats: 'statsetup'

task :statsetup do
  require 'rails/code_statistics'

  custom_directories = [
    %w[Channels app/channels],
    %w[Controllers app/controllers],
    %w[Listeners app/listeners],
    %w[Models app/models],
    %w[Services app/services],
    ['Services specs', 'spec/services']
  ]
  STATS_DIRECTORIES.replace(custom_directories)

  custom_test_types = ["Service specs"]
  CodeStatistics::TEST_TYPES.replace(custom_test_types)
end

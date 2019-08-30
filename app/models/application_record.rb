# frozen_string_literal: true

# rubocop:disable Style/Documentation
class ApplicationRecord < ActiveRecord::Base
  # rubocop:enable Style/Documentation
  self.abstract_class = true
end

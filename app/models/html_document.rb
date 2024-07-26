class HtmlDocument < ApplicationRecord
  enum :processed_status, { created: 0, in_process: 1, error: 2, parsed: 3 }
end

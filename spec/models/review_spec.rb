require 'rails_helper'

describe Review do
  it { should belong_to(:restaurant).dependent(:destroy) }
end

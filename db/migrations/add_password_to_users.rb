require_relative '../../config/database'

DB.alter_table :users do
  add_column :password, String
end

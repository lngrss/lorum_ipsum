require_relative '../../config/database'

DB.create_table :messages do
  primary_key :id
  foreign_key :user_id, :users
  String :text
end

DB.alter_table :users do
  drop_column :text
end

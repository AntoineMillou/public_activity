# frozen_string_literal: true

# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration[5.0]
  def self.up
    create_table :activities do |t|
      t.belongs_to :trackable, polymorphic: true
      t.belongs_to :owner, polymorphic: true
      t.string :uuid, limit: 36, null: false
      t.string :key
      t.json :parameters
      t.belongs_to :recipient, polymorphic: true
      t.index :uuid, unique: true
      t.timestamps
    end

    add_index :activities, %i[trackable_id trackable_type]
    add_index :activities, %i[owner_id owner_type]
    add_index :activities, %i[recipient_id recipient_type]
  end

  # Drop table
  def self.down
    drop_table :activities
  end
end
